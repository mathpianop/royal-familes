class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :sex
      t.integer :father_id
      t.index :father_id
      t.integer :mother_id
      t.index :mother_id
      t.integer :birth_date
      t.integer :death_date
      t.string :name
      t.timestamps
    end
  end
end
