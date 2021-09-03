class AddForeignKeyToPersonIdOnMarriages < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :marriages, :people
  end
end
