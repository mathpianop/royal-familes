class Person < ApplicationRecord
  has_parents ineligibility: :pedigree_and_dates
  has_many :husbanded_marriages, foreign_key: :husband_id, class_name: "Marriage"
  has_many :wifed_marriages, foreign_key: :wife_id, class_name: "Marriage"
  has_many :wives, through: :husbanded_marriages, source: :wife
  has_many :husbands, through: :wifed_marriages, source: :husband
  validate :birth_must_be_before_death

  def birth_must_be_before_death
    if birth_date && death_date 
      errors.add(:base, "Birth date must be before death date") unless birth_date < death_date
    end
  end


  #   parent_ids_temp = people.map{|person| [person.id]}
  #   parent_ids_store = parent_ids_temp.clone

  #   generation_count = 1

  #   while parent_ids_temp.select{|array_of_ids| array_of_ids.length > 0}.length > 0
  #     next_gen_ids = parent_ids_temp.map{|ids| gclass.where(id: ids).select([:father_id, :mother_id]).map{|result| [result.father_id, result.mother_id]}.flatten.compact}

  #     next_gen_ids.each_with_index do |ids, index|
  #       parent_ids_store[index] += ids
  #       parent_ids_temp[index]   = ids
  #     end

  #     if parent_ids_store.reduce(:&).length > 0
  #       return gclass.where(id: (parent_ids_store.reduce(:&)))
  #     else
  #       generation_count += 1
  #     end
  #   end
  #   gclass.where(id: nil)
  # end

  #These query methods are modeled after the lowest_common_ancestors method in the genealogy gem
  #https://github.com/masciugo/genealogy

  
  def ancestors
    ancestors_store = []
    ancestors_temp = self.parents.compact
    
    while ancestors_temp.length > 0
      ancestors_store << ancestors_temp
      next_gen_ids = ancestors_temp.map{|ancestor| [ancestor.father_id, ancestor.mother_id]}.flatten.compact
      ancestors_temp = self.class.where(id: next_gen_ids).select(:id, :name, :father_id, :mother_id)
    end
    ancestors_store
  end


  def descendants
    descendants_store = []
    descendants_temp = self.children
    
    while descendants_temp.length > 0
      descendants_store << descendants_temp
      current_gen_ids = descendants_temp.map(&:id)
      next_gen = self.class.where(father_id: current_gen_ids).or(self.class.where(mother_id: current_gen_ids))
      descendants_temp = next_gen.select(:id, :name, :father_id, :mother_id)
    end
    descendants_store
  end
end
