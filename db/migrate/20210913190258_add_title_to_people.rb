class AddTitleToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :title, :string
    add_index :people, [:name, :title], unique: true
  end
end
