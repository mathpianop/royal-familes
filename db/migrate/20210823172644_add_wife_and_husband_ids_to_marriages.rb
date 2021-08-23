class AddWifeAndHusbandIdsToMarriages < ActiveRecord::Migration[6.1]
  def change
    add_reference :marriages, :husband
    add_reference :marriages, :wife
  end
end
