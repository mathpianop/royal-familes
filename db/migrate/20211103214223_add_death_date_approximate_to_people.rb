class AddDeathDateApproximateToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :death_date_approximate, :boolean
  end
end
