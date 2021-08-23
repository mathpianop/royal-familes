class Marriage < ApplicationRecord
  belongs_to :husband, class_name: "Person"
  belongs_to :wife, class_name: "Person"
end
