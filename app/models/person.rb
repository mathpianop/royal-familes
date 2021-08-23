class Person < ApplicationRecord
  has_parents ineligibility: :pedigree_and_dates
  validates birth_date, unless: -> {birth_date > death_date}
  validates death_date, unless: -> {birth_date > death_date}

end
