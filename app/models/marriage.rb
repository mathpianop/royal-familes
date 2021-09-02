class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "Person"
  belongs_to :wife, class_name: "Person"
  validates_presence_of :wife
  validates_presence_of :husband
  validate :genders_are_correct
  validate :spouses_are_contemporary

  private

  #See README for explanation of heteronormativity
  def genders_are_correct
    errors.add(:base, "Husband must be male and wife must be female") unless self.husband.sex == "M" && self.wife.sex == "F"
  end

  def lifespans_overlap?
    spouses = Person.where(id: [self.husband_id, self.wife_id])
    # Ensure that one spouse was born before the other died, unless there is a date missing
    if spouses.all? {|spouse| spouse.birth_date && spouse.death_date}
      p "Hellow"
      self.husband.death_date > self.wife.birth_date && self.wife.death_date > self.husband.birth_date
    else
      true
    end
  end

  def spouses_are_contemporary
    errors.add(:base, "Spouses must have overlapped in time") if !lifespans_overlap?
  end
end