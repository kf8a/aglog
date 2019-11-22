# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_22_185355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "observation_id"
    t.integer "operation_type_id"
    t.text "comment"
    t.float "hours"
  end

  create_table "areas", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "replicate"
    t.integer "study_id"
    t.integer "treatment_id"
    t.text "description"
    t.integer "company_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
    t.boolean "retired"
  end

  create_table "areas_observations", id: false, force: :cascade do |t|
    t.integer "observation_id"
    t.integer "area_id"
  end

  create_table "collaborations", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "use_material", default: false
    t.boolean "is_tractor", default: false
    t.text "description"
    t.boolean "archived"
    t.integer "company_id"
    t.text "salus_code"
    t.integer "equipment_type_id"
    t.boolean "non_msu", default: false
  end

  create_table "equipment_materials", id: false, force: :cascade do |t|
    t.integer "equipment_id"
    t.integer "material_id"
  end

  create_table "equipment_operation_types", id: false, force: :cascade do |t|
    t.integer "equipment_id"
    t.integer "operation_type_id"
  end

  create_table "equipment_pictures", id: :serial, force: :cascade do |t|
    t.integer "equipment_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
  end

  create_table "equipment_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "material_transactions", id: :serial, force: :cascade do |t|
    t.integer "material_id"
    t.integer "unit_id"
    t.integer "setup_id"
    t.float "rate"
    t.integer "cents"
    t.integer "material_transaction_type_id"
    t.datetime "transaction_datetime"
  end

  create_table "material_types", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "materials", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "operation_type_id"
    t.integer "material_type_id"
    t.float "n_content"
    t.float "p_content"
    t.float "k_content"
    t.float "specific_weight", default: 1.0
    t.boolean "liquid"
    t.integer "company_id"
    t.boolean "archived", default: false
    t.text "salus_code"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_company", default: false
  end

  create_table "observation_types", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "observation_types_observations", id: false, force: :cascade do |t|
    t.integer "observation_id"
    t.integer "observation_type_id"
  end

  create_table "observations", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.text "comment"
    t.date "obs_date"
    t.date "created_on"
    t.string "state"
    t.integer "company_id"
    t.string "note"
    t.json "notes"
  end

  create_table "open_id_authentication_associations", id: :serial, force: :cascade do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string "handle"
    t.string "assoc_type"
    t.binary "server_url"
    t.binary "secret"
  end

  create_table "open_id_authentication_nonces", id: :serial, force: :cascade do |t|
    t.integer "timestamp", null: false
    t.string "server_url"
    t.string "salt", null: false
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "given_name"
    t.string "sur_name"
    t.string "openid_identifier"
    t.string "persistence_token"
    t.string "password_salt"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "company_id"
    t.boolean "archived", default: false
    t.integer "user_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "setups", id: :serial, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "equipment_id"
    t.string "settings"
  end

  create_table "studies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
  end

  create_table "treatments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "study_id"
    t.integer "treatment_number"
  end

  create_table "units", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "si_unit_id"
    t.float "conversion_factor"
    t.boolean "is_si_unit", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
