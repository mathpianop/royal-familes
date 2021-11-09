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

ActiveRecord::Schema.define(version: 2021_11_09_211251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "marriage_relationships", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "marriage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["marriage_id"], name: "index_marriage_relationships_on_marriage_id"
    t.index ["person_id"], name: "index_marriage_relationships_on_person_id"
  end

  create_table "marriages", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "person_id"
    t.integer "consort_id"
    t.index ["consort_id"], name: "index_marriages_on_consort_id"
    t.index ["person_id"], name: "index_marriages_on_person_id"
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
    t.string "title"
    t.boolean "birth_date_approximate"
    t.boolean "death_date_approximate"
    t.index ["father_id", "mother_id"], name: "index_people_on_father_id_and_mother_id"
    t.index ["father_id"], name: "index_people_on_father_id"
    t.index ["mother_id", "father_id"], name: "index_people_on_mother_id_and_father_id"
    t.index ["mother_id"], name: "index_people_on_mother_id"
    t.index ["name", "title"], name: "index_people_on_name_and_title", unique: true
  end

  add_foreign_key "marriages", "people"
end
