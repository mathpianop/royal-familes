class RenameSpouseIdToConsortIdOnMarriages < ActiveRecord::Migration[6.1]
  def change
    rename_column :marriages, :spouse_id, :consort_id
  end
end
