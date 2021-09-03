class Marriage < ApplicationRecord
  validates_presence_of :person
  validates_presence_of :consort
  validate :genders_are_correct
  validate :consorts_are_contemporary
  belongs_to :person
  belongs_to :consort, class_name: "Person"
  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?


  def create_inverse
    self.class.create(inverse_marriage_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.exists?(inverse_marriage_options)
  end

  def inverses
    self.class.where(inverse_marriage_options)
  end

  def inverse_marriage_options
    { consort_id: person_id, person_id: consort_id }
  end

  private

  #See README for explanation of heteronormativity
  def genders_are_correct
    errors.add(:base, "Marriage cannot be same-sex") if self.person.sex == self.consort.sex
  end

  def lifespans_overlap?
    spouses = Person.where(id: [self.person_id, self.consort_id])
    # Ensure that one spouse was born before the other died, unless there is a date missing
    if spouses.all? {|spouse| spouse.birth_date && spouse.death_date}
      spouses[0].death_date > spouses[1].birth_date && spouses[1].death_date > spouses[1].birth_date
    else
      true
    end
  end

  def consorts_are_contemporary
    errors.add(:base, "Spouses must have overlapped in time") if !lifespans_overlap?
  end
end