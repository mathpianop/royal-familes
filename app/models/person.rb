class Person < ApplicationRecord
  has_parents ineligibility: :pedigree_and_dates
end
