class CreateMarriages < ActiveRecord::Migration[6.1]
  def change
    create_table :marriages do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
