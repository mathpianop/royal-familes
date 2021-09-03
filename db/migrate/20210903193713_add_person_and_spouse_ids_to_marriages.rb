class AddPersonAndSpouseIdsToMarriages < ActiveRecord::Migration[6.1]
  def change
    add_column :marriages, :person_id, :integer, index: true
    add_column :marriages, :spouse_id, :integer, index: true
  end
end
