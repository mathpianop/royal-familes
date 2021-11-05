class AddBirthDateApproximateToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :birth_date_approximate, :boolean
  end
end
