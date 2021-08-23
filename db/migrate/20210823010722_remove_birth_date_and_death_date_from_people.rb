class RemoveBirthDateAndDeathDateFromPeople < ActiveRecord::Migration[6.1]
  def change
    remove_column :people, :birth_date
    remove_column :people, :death_date
  end
end
