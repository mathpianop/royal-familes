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

  def birth_must_be_before_death
    if birth_date && death_date 
      errors.add(:base, "Birth date must be before death date") unless birth_date < death_date
    end
  end

  def parent_id_name
    self.sex == "F" ? :mother_id : :father_id
  end


  def self.relationship_info(subject_id, relation_id)
    self.find(subject_id).relationship_info(self.find(relation_id))
  end

  def set_child_ids(ids)
    self.class.where(parent_id_name => self.id).where.not(id: ids).update_all(parent_id_name => nil)
    children = self.class.where(id: ids)
    children.update(parent_id_name => self.id)
    children.each {|child| child.errors[:parent].each {|error| self.errors.add(:parent, error)}}
    self.errors.messages.empty?
  end

  
end
