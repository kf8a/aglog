# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161202163346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"

  create_table "activities", force: :cascade do |t|
    t.integer "person_id"
    t.integer "observation_id",    null: false
    t.integer "operation_type_id"
    t.text    "comment"
    t.float   "hours"
  end

  add_index "activities", ["observation_id"], name: "activity_observation_id_idx", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.integer "replicate"
    t.integer "study_id"
    t.integer "treatment_id"
    t.text    "description"
    t.integer "company_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "parent_id"
  end

  create_table "areas_observations", id: false, force: :cascade do |t|
    t.integer "observation_id"
    t.integer "area_id"
  end

  add_index "areas_observations", ["observation_id", "area_id"], name: "areas_observation_idx", unique: true, using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", force: :cascade do |t|
    t.string  "name",              limit: 255
    t.boolean "use_material",                  default: false
    t.boolean "is_tractor",                    default: false
    t.integer "company_id"
    t.text    "description"
    t.boolean "archived"
    t.text    "salus_code"
    t.integer "equipment_type_id"
    t.boolean "non_msu",                       default: false
  end

  create_table "equipment_materials", id: false, force: :cascade do |t|
    t.integer "equipment_id"
    t.integer "material_id"
  end

  create_table "equipment_operation_types", id: false, force: :cascade do |t|
    t.integer "equipment_id"
    t.integer "operation_type_id"
  end

  create_table "equipment_pictures", force: :cascade do |t|
    t.integer  "equipment_id"
    t.string   "title",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "equipment_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "material_transactions", force: :cascade do |t|
    t.integer  "material_id",                  null: false
    t.integer  "unit_id"
    t.integer  "setup_id"
    t.float    "rate"
    t.integer  "cents"
    t.integer  "material_transaction_type_id"
    t.datetime "transaction_datetime"
  end

  create_table "material_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "materials", force: :cascade do |t|
    t.string  "name",              limit: 255
    t.integer "operation_type_id"
    t.integer "material_type_id"
    t.float   "n_content"
    t.float   "p_content"
    t.float   "k_content"
    t.float   "specific_weight",               default: 1.0
    t.boolean "liquid"
    t.integer "company_id"
    t.boolean "archived",                      default: false
    t.text    "salus_code"
  end

  create_table "observation_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "observation_types_observations", id: false, force: :cascade do |t|
    t.integer "observation_id"
    t.integer "observation_type_id"
  end

  create_table "observations", force: :cascade do |t|
    t.integer  "person_id"
    t.text     "comment"
    t.date     "obs_date"
    t.date     "created_on"
    t.string   "state",      limit: 255
    t.integer  "company_id"
    t.string   "note",       limit: 255
    t.json     "notes"
    t.datetime "updated_at"
  end

  add_index "observations", ["obs_date"], name: "observation_date_idx", using: :btree

  create_table "open_id_authentication_associations", force: :cascade do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle",     limit: 255
    t.string  "assoc_type", limit: 255
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", force: :cascade do |t|
    t.integer "timestamp",              null: false
    t.string  "server_url", limit: 255
    t.string  "salt",       limit: 255, null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "given_name",        limit: 255
    t.string   "sur_name",          limit: 255
    t.string   "openid_identifier", limit: 255
    t.string   "password_salt",     limit: 255
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token", limit: 255
    t.integer  "company_id"
    t.boolean  "archived",                      default: false
    t.integer  "user_id"
  end

  create_table "schema_info", id: false, force: :cascade do |t|
    t.integer "version"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "setups", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "equipment_id"
    t.string  "settings",     limit: 255
  end

  add_index "setups", ["activity_id"], name: "setups_activity_id_idx", using: :btree
  add_index "setups", ["equipment_id"], name: "setups_equipment_id_idx", using: :btree

  create_table "studies", force: :cascade do |t|
    t.string "name",        limit: 255
    t.text   "description"
  end

  create_table "treatments", force: :cascade do |t|
    t.string  "name",             limit: 255
    t.integer "study_id"
    t.integer "treatment_number"
  end

  create_table "units", force: :cascade do |t|
    t.string  "name",              limit: 255
    t.integer "si_unit_id"
    t.float   "conversion_factor"
    t.boolean "is_si_unit",                    default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "observations", "companies", name: "observations_company_id_fkey"
  add_foreign_key "observations", "people", name: "observations_person_id_fkey"
end
