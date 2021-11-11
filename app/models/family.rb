class Family

  def initialize(person)
    @person = person
  end


  def parents
    parent_records = Person.where(id: [@person.mother_id, @person.father_id])
    {
      female: parent_records.find{ |parent| parent.sex == "F"}, 
      male: parent_records.find{ |parent| parent.sex == "M"}
    }
  end

  def spouses
    @person.consorts.load
  end


  def grandparents_on_side(gparent_records, sex)
    return [] if !parents[sex]
    gparents_on_side = gparent_records.select do |gparent| 
      gparent.id == parents[sex].father_id || 
      gparent.id == parents[sex].mother_id
    end
    gparents_on_side.sort_by{ |gparent| gparent.sex }.reverse
  end

  

  def grandparents
    gparent_ids = parents.values.compact.flat_map{|par| [par.mother_id, par.father_id]}
    gparent_records = Person.where(id: gparent_ids)
    
    maternal_gparents = grandparents_on_side(gparent_records, :female)
    paternal_gparents = grandparents_on_side(gparent_records, :male)
    {maternal: maternal_gparents, paternal: paternal_gparents}
  end


  def children(ids = @person.id)
    Person.where(mother_id: ids).where.not(mother_id: nil)
          .or(Person.where(father_id: ids).where.not(father_id: nil)).load
  end

  def grandchildren
    children_ids = children.map(&:id)
    grandchild_records = children(children_ids)
    grandchild_records.group_by do |record| 
      children_ids.find {|id| id == record.father_id || id == record.mother_id}
    end
  end
  
  def siblings_on_side(gender)
    parent_id = (gender == "F" ? :mother_id : :father_id)
    Person.where(parent_id => @person[parent_id]).where.not(parent_id => nil)
  end
  
  def siblings
    siblings_on_side("M").or(siblings_on_side("F")).where.not(id: @person.id).load
  end




  # These query methods are modeled after the lowest_common_ancestors method in the genealogy gem
  # https://github.com/masciugo/genealogy
  # They are conscious implementations of N + 1 queries until Neo4j or recursive SQL solutions
  # can be explored

  def sort_by_birth_order(people)
    # Return the people in birth order, putting those without a given birth_date at the end
    people.sort do |a,b|
      a.birth_date && b.birth_date ? a.birth_date <=> b.birth_date : a.birth_date ? -1 : 1 
    end
  end

  def ancestors
    ancestors_store = []
    ancestor_ids = []
    current_gen_temp = parents.values.compact
    
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
      current_gen_temp = Person.where(id: next_gen_ids)
                                   .where.not(id: ancestor_ids)
                                   .select(:id, :name, :father_id, :mother_id, :birth_date)
    end
    
    sort_by_birth_order(ancestors_store)
  end

  def descendants
    descendants_store = []
    descendant_ids = []
    current_gen_temp = children.load
    
    while current_gen_temp.length > 0 
      # Add the current generation to the descendants store
      descendants_store.concat(current_gen_temp)
      # Add the current generation ids to the ids store
      current_gen_ids = current_gen_temp.map(&:id)
      descendant_ids.concat(current_gen_ids)
      # Get the corresponding descendants,
      # not including duplicates from cousins with removal
      current_gen_temp = Person.where(father_id: current_gen_ids)
                                   .or(Person.where(mother_id: current_gen_ids))
                                   .where.not(id: descendant_ids)
                                   .select(:id, :name, :father_id, :mother_id, :birth_date)
    end
    sort_by_birth_order(descendants_store)
  end


  
end