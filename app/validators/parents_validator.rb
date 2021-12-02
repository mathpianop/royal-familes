class ParentsValidator < ActiveModel::Validator

  def validate(person)
    confirm_parents_correct_genders(person)
    confirm_parents_not_person(person)
    confirm_parents_not_spouse(person)
    confirm_parents_not_descendants(person)
    confirm_parents_not_ancestors(person)
  end

  private

  def confirm_father_is_male(person)
    if person.father_id && person.class.find(person.father_id).sex == "F"
      person.errors.add(:father, "must be male")
      throw :abort
    end
  end

  def confirm_mother_is_female(person)
    if person.mother_id && person.class.find(person.mother_id).sex == "M"
      person.errors.add(:mother, "must be female")
      throw :abort
    end
  end

  def confirm_parents_correct_genders(person)
    confirm_father_is_male(person) || confirm_mother_is_female(person)
  end

  def confirm_parents_not_spouse(person)
    if (person.consorts.any?{ |consort| consort == person.father || consort == person.mother})
      person.errors.add(:parent, "can't be a spouse")
      throw :abort
    end
  end

  def confirm_parents_not_descendants(person)
    family = Family.new(person)
    if family.descendants.any? {|desc| desc.id == person.father_id || desc.id == person.mother_id }
      person.errors.add(:parent, "can't be a descendant")
      throw :abort
    end
  end

  def confirm_parents_not_person(person)
    if person.id && (person.father_id == person.id || person.mother_id == person.id) 
      person.errors.add(:parent, "can't be oneself")
      throw :abort
    end
  end

  def confirm_parents_not_ancestors(person)
    family = Family.new(person, true)
    if family.ancestors_without_parents.any? {|anc| anc.id == person.father_id || anc.id == person.mother_id }
      person.errors.add(:parent, "can't be an ancestor")
      throw :abort
    end
  end
end