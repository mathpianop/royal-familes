class Person < ApplicationRecord
  include PgSearch::Model
  include ActiveModel::Validations
  include Relationship
  before_destroy :confirm_no_children
  belongs_to :father, class_name: "Person", optional: true
  belongs_to :mother, class_name: "Person", optional: true
  has_many :marriages
  has_many :consorts, through: :marriages, foreign_key: :consort_id
  accepts_nested_attributes_for :consorts, allow_destroy: true
  validates :name, presence: true, uniqueness: { scope: :title }
  validates :birth_date, presence: true
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
  def grandparents_on_side(gparent_records, sex)
    return [] if !parents[sex]
    gparents_on_side = gparent_records.select do |gparent| 
      gparent.id == parents[sex].father_id || 
      gparent.id == parents[sex].mother_id
    end
    gparents_on_side.sort_by{ |gparent| gparent.sex }.reverse
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
    self.class.where(mother_id: ids).where.not(mother_id: nil)
              .or(self.class.where(father_id: ids).where.not(father_id: nil))
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
  
end
