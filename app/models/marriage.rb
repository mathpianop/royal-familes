class Marriage < ApplicationRecord
  validates_presence_of :person
  validates_presence_of :consort
  validate :genders_are_correct
  validate :spouse_not_ancestor_or_descendant
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

  def genders_are_correct
    if self.person.sex == self.consort.sex
      self.person.errors.add(:base, "Marriage cannot be same-sex")
      throw :abort
    end
  end

  def spouse_is_ancestor_or_descendant
    family = Family.new(self.person)
    family.ancestors.any? {|anc| anc.id == self.consort.id} ||
    family.descendants.any? {|desc|desc.id == self.consort.id}
  end

  def spouse_not_ancestor_or_descendant
    p "Hello"
    if spouse_is_ancestor_or_descendant
      p "Hello #{self.person.name}"
      self.errors.add(:spouse, "can't be an ancestor or descendant")
      self.person.errors.add(:spouse, "can't be an ancestor or descendant")
      self.consort.errors.add(:spouse, "can't be an ancestor or descendant")
      throw :abort
    end
  end



end