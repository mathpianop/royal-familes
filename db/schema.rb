# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_23_182107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "marriages", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "husband_id", null: false
    t.bigint "wife_id", null: false
    t.index ["husband_id"], name: "index_marriages_on_husband_id"
    t.index ["wife_id"], name: "index_marriages_on_wife_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "sex"
    t.integer "father_id"
    t.integer "mother_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "birth_date"
    t.date "death_date"
    t.index ["father_id", "mother_id"], name: "index_people_on_father_id_and_mother_id"
    t.index ["father_id"], name: "index_people_on_father_id"
    t.index ["mother_id", "father_id"], name: "index_people_on_mother_id_and_father_id"
    t.index ["mother_id"], name: "index_people_on_mother_id"
  end

end
