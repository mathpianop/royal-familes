



class Person < ApplicationRecord
  has_parents ineligibility: :pedigree_and_dates
  has_many :husbanded_marriages, foreign_key: :husband_id, class_name: "Marriage"
  has_many :wifed_marriages, foreign_key: :wife_id, class_name: "Marriage"
  has_many :wives, through: :husbanded_marriages, source: :wife
  has_many :husbands, through: :wifed_marriages, source: :husband
  validate :birth_must_be_before_death

  def birth_must_be_before_death
    errors.add(:base, "Birth date must be before death date") if birth_date > death_date
  end
end
