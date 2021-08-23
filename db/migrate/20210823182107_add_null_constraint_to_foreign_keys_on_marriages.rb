class AddNullConstraintToForeignKeysOnMarriages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :marriages, :husband_id, false
    change_column_null :marriages, :wife_id, false
  end
end
