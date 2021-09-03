class AddIndexToPersonAndSpouseIdsOnMarriages < ActiveRecord::Migration[6.1]
  def change
    add_index :marriages, :person_id
    add_index :marriages, :spouse_id
  end
end
