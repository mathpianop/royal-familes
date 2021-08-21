class AddCompoundIndexesToPeople < ActiveRecord::Migration[6.1]
  def change
    add_index :people, [:father_id, :mother_id]
    add_index :people, [:mother_id, :father_id]
  end
end
