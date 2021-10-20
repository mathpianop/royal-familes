class Person < ApplicationRecord
  include PgSearch::Model
  include ActiveModel::Validations
  before_destroy :confirm_no_children
  belongs_to :father, class_name: "Person"
  belongs_to :mother, class_name: "Person"
  has_many :marriages
  has_many :consorts, through: :marriages, foreign_key: :consort_id
  validates :name, presence: true, uniqueness: { scope: :title }
  validate :birth_must_be_before_death
  validates_with ParentsValidator
  pg_search_scope :search_by_name_or_title, against: [:name, :title],
    using: {
        tsearch: {
          prefix: true,
          any_word: true
        }
      }


  def confirm_no_children
    if self.class.where(parent_id_name => self.id).exists?
      errors.add(:base, "You cannot delete a person with children")
      throw :abort
    end
  end

  def parents
    parent_records = self.class.where(id: [self.mother_id, self.father_id])
    {
      female: parent_records.find{ |parent| parent.sex == "F"}, 
      male: parent_records.find{ |parent| parent.sex == "M"}
    }
  end

  # This method needs to be private
  def grandparents_on_side(gparent_records, gender)
    return [] if !parents[gender]
    gparent_records.select do |gparent| 
      gparent.id == parents[gender].father_id || 
      gparent.id == parents[gender].mother_id
    end
  end

  def grandparents(parents = self.parents)
    gparent_ids = parents.values.compact.flat_map{|par| [par.mother_id, par.father_id]}
    gparent_records = self.class.where(id: gparent_ids)
    
    maternal_gparents = grandparents_on_side(gparent_records, :female)
    paternal_gparents = grandparents_on_side(gparent_records, :male)
    {maternal: maternal_gparents, paternal: paternal_gparents}
  end


  def birth_must_be_before_death
    if birth_date && death_date 
      errors.add(:base, "Birth date must be before death date") unless birth_date < death_date
    end
  end

  def parent_id_name
    self.sex == "F" ? :mother_id : :father_id
  end

  def children(ids = self.id)
    self.class.where(mother_id: ids).or(self.class.where(father_id: ids))
  end

  def grandchildren(children = self.children)
    children_ids = children.map(&:id)
    grandchild_records = children(children_ids)
    grandchild_records.group_by do |record| 
      children_ids.find {|id| id == record.father_id || id == record.mother_id}
    end
  end
  
  def siblings_on_side(gender)
    parent_id = (gender == "F" ? :mother_id : :father_id)
    self.class.where(parent_id => self[parent_id]).where.not(parent_id => nil)
  end
  
  def siblings
    siblings_on_side("M").or(siblings_on_side("F")).where.not(id: self.id)
  end

  def family
    {
      parents: parents,
      grandparents: grandparents,
      children: children,
      grandchildren: grandchildren,
      siblings: siblings,
      spouses: consorts
    }
  end


  # These query methods are modeled after the lowest_common_ancestors method in the genealogy gem
  # https://github.com/masciugo/genealogy

  def sort_by_birth_order(people)
    # Return the people in birth order, putting those without a given birth_date at the end
    people.sort do |a,b|
      a.birth_date && b.birth_date ? a.birth_date <=> b.birth_date : a.birth_date ? -1 : 1 
    end
  end

  def ancestors
    ancestors_store = []
    ancestor_ids = []
    current_gen_temp = self.parents.values.compact
    
    while current_gen_temp.length > 0
      # Add the current generation to the ancestors store
      ancestors_store.concat(current_gen_temp)
      # Add the current generation ids to the ids store,
      # disregarding duplicates from cousins without removal
      ancestor_ids.concat(current_gen_temp.map(&:id).uniq)
      # Get the ids of the next generation up
      next_gen_ids = current_gen_temp.map{|ancestor| [ancestor.father_id, ancestor.mother_id]}.flatten.compact
      # Get the corresponding ancestors,
      # not including duplicates from cousins with removal
      current_gen_temp = self.class.where(id: next_gen_ids)
                                   .where.not(id: ancestor_ids)
                                   .select(:id, :name, :father_id, :mother_id, :birth_date)
    end
    
    sort_by_birth_order(ancestors_store)
  end

  def descendants
    descendants_store = []
    descendant_ids = []
    current_gen_temp = self.children
    
    while current_gen_temp.length > 0 
      # Add the current generation to the descendants store
      descendants_store.concat(current_gen_temp)
      # Add the current generation ids to the ids store
      current_gen_ids = current_gen_temp.map(&:id)
      descendant_ids.concat(current_gen_ids)
      # Get the corresponding descendants,
      # not including duplicates from cousins with removal
      current_gen_temp = self.class.where(father_id: current_gen_ids)
                                   .or(self.class.where(mother_id: current_gen_ids))
                                   .where.not(id: descendant_ids)
                                   .select(:id, :name, :father_id, :mother_id, :birth_date)
    end
    sort_by_birth_order(descendants_store)
  end

  def self.relationship_info(subject_id, relation_id)
    self.find(subject_id).relationship_info(self.find(relation_id))
  end

  def relationship_info(person)
    ancestry_connection = ancestry_connection(self, person)
    if (ancestry_connection)
      return {
        relationship: blood_relationship(ancestry_connection),
        lowest_common_ancestors: self.class.where(id: ancestry_connection[:lowest_common_ancestors]).select(:name, :id)
      }
    else
      return {relationship: relationship_by_marriage(self, person)}
    end
  end

  private 

  def ancestry_connection(person_1, person_2)
    parent_ids_store = [[[person_1.id]], [[person_2.id]]]
    parent_ids_temp = [[person_1.id], [person_2.id]]
    
    while parent_ids_temp.any? {|ids| ids.length > 0}
      
      next_gen_ids = parent_ids_temp.map do |ids| 
        self.class.where(id: ids)
                  .select(:father_id, :mother_id)
                  .map{|result| [result.father_id, result.mother_id]}
                  .flatten
                  .compact 
      end

      next_gen_ids.each_with_index do |ids, index|
        parent_ids_store[index] << ids
        parent_ids_temp[index] = ids
      end
          
      possible_lowest_common_ancestors = parent_ids_store.map(&:flatten).reduce(:&)
      if possible_lowest_common_ancestors.length > 0
        return {
          striated_ancestor_ids: parent_ids_store, 
          lowest_common_ancestors: possible_lowest_common_ancestors,
          sex: person_2.sex
        }
      end
    end
    nil
  end


  def generation_counts(ancestry_connection)
    ancestry_connection[:striated_ancestor_ids].map do |generations| 
      generations.index {|generation| generation.include?(ancestry_connection[:lowest_common_ancestors][0])}
    end
  end

  def blood_relationship(ancestry_connection)
    counts = generation_counts(ancestry_connection)
    if counts.min == 0
      direct_relationship(counts, ancestry_connection)
    elsif counts.min > 0
      indirect_relationship(counts, ancestry_connection)
    end
  end

  def direct_relationship(generation_counts, ancestry_connection)
    sex = ancestry_connection[:sex]
    if generation_counts[0] == 0
      root_relationship = descendant_relationship((generation_counts[1] - generation_counts[0]), sex)
    elsif generation_counts[1] == 0
      root_relationship = ancestor_relationship((generation_counts[0] - generation_counts[1]), sex)
    end
    root_plus_greats(root_relationship, generation_counts)
  end

  def descendant_relationship(generation_gap, sex)
    if generation_gap == 1
      sex == "M" ? "son" : "daughter"
    elsif generation_gap > 1
      sex == "M" ? "grandson" : "daughter"
    end
  end

  def ancestor_relationship(generation_gap, sex)
    if generation_gap == 1
      sex == "F" ? "mother" : "father"
    elsif generation_gap > 1
      sex == "F" ? "grandmother" : "grandfather"
    end
  end

  def indirect_relationship(generation_counts, ancestry_connection)
    sex = ancestry_connection[:sex]
    if generation_counts.min == 1
      #sibling, auntcle, great-auntcle, neicphew, great-neicphiew, etc....
      root_relationship = neo_sibling_relationship(generation_counts, sex)
    elsif generation_counts.min > 1
      root_relationship = cousin_relationship(generation_counts)
    end

    if ancestry_connection[:lowest_common_ancestors].length == 1
      return "half #{root_relationship}"
    else
      return root_relationship
    end
  end

  def neo_sibling_relationship(generation_counts, sex)
   if generation_counts.all?(1)
    sibling_relationship(sex)
   else
    auntcle_relationship(generation_counts, sex)
   end
  end

  def sibling_relationship(sex)
    sex == "M" ? "brother" : "sister"
  end

  def auntcle_relationship(generation_counts, sex)
    if generation_counts[0] == 1
      root_relationship = (sex == "F" ? "neice" : "nephew")
    elsif generation_counts[1] == 1
      root_relationship = (sex == "F" ? "aunt" : "uncle")
    end

    root_plus_greats(root_relationship, generation_counts)
  end


  def root_plus_greats(root, generation_counts)
    num_of_greats = generation_counts.max - 2
    num_of_greats > 0  ? "#{"great-"*num_of_greats}#{root}" : root
  end
  

  def cousin_relationship(generation_counts)
    number_of_times = ["once", "twice"]
    removal = generation_counts.max - generation_counts.min
    root_relationship = "#{(generation_counts.min - 1).ordinalize} cousin"
    root_relationship += " #{number_of_times[removal - 1]} removed" if removal == 1 || removal == 2
    root_relationship += " #{removal} times removed" if removal > 2
    root_relationship
  end

  def relationship_by_marriage(person_1, person_2)
    if spouse_relationship?(person_1, person_2)
      person_2.sex == "M" ? "husband" : "wife"
    elsif child_in_law_relationship?(person_1, person_2)
      person_2.sex == "M" ? "son-in-law" : "daughter-in-law"
    elsif child_in_law_relationship?(person_2, person_1)
      person_2.sex == "M" ? "father-in-law" : "mother-in-law"
    elsif sibling_in_law_relationship?(person_1, person_2)
      person_2.sex == "M" ? "brother-in-law" : "sister-in-law"
    end
  end

  def child_in_law_relationship?(person_1, person_2)
    parent_id = person_1.parent_id_name
    children_in_law_ids = Person.joins(:consorts).where(consorts: {parent_id => person_1.id}).pluck(:id)
    children_in_law_ids.include?(person_2.id)
  end

  def spouse_relationship?(person_1, person_2)
    person_1.consorts.pluck(:id).include?(person_2.id)
  end

  def sibling_in_law_relationship?(person_1, person_2)
    siblings_of_spouses = Person.joins(:consorts).where(consorts: {father_id: person_2.father_id, mother_id: person_2.mother_id})
    spouses_of_siblings = Person.joins(:consorts).where(consorts: {father_id: person_1.father_id, mother_id: person_1.mother_id})
    sibling_in_law_ids = siblings_of_spouses.or(spouses_of_siblings).pluck(:id)
    sibling_in_law_ids.include?(person_1.id) || sibling_in_law_ids.include?(person_2.id)
  end
end
