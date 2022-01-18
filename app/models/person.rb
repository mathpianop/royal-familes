class Person 
  include ActiveGraph::Node
  property :sex, type: String
  property :title, type: String
  property :name, type: String
  property :death_date, type: Date
  property :birth_date, type: Date
  property :birth_date_approximate, type: String
  property :death_date_approximate, type: String
  property :created_at
  property :updated_at
  validates :birth_date, presence: true
  validates :sex, presence: true
  validates :name, presence: true, uniqueness: { scope: :title }
end