class RemoveHusbandAndWifeIdsFromMarriages < ActiveRecord::Migration[6.1]
  def change
    remove_column :marriages, :husband_id
    remove_column :marriages, :wife_id
  end
end
