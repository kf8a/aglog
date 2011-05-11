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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110511174713) do

  create_table "activities", :force => true do |t|
    t.integer "person_id"
    t.integer "observation_id",    :null => false
    t.integer "operation_type_id"
    t.text    "comment"
    t.float   "hours"
  end

  create_table "areas", :force => true do |t|
    t.string  "name"
    t.integer "replicate"
    t.integer "study_id"
    t.integer "treatment_id"
    t.string  "description"
    t.integer "company_id"
  end

  create_table "areas_observations", :id => false, :force => true do |t|
    t.integer "observation_id"
    t.integer "area_id"
  end

  add_index "areas_observations", ["observation_id", "area_id"], :name => "areas_observation_idx", :unique => true

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", :force => true do |t|
    t.string  "name"
    t.boolean "use_material", :default => false
    t.boolean "is_tractor",   :default => false
    t.integer "company_id"
    t.string  "description"
    t.boolean "archived"
  end

  create_table "equipment_materials", :id => false, :force => true do |t|
    t.integer "equipment_id"
    t.integer "material_id"
  end

  create_table "equipment_operation_types", :id => false, :force => true do |t|
    t.integer "equipment_id"
    t.integer "operation_type_id"
  end

  create_table "hazards", :force => true do |t|
    t.string "name"
    t.string "hazard_type"
    t.string "chemical_name"
    t.text   "description"
    t.text   "notification"
    t.float  "exclusion_time_days"
  end

  create_table "hazards_materials", :id => false, :force => true do |t|
    t.integer "hazard_id"
    t.integer "material_id"
  end

  create_table "hazards_people", :id => false, :force => true do |t|
    t.integer "hazard_id"
    t.integer "person_id"
  end

  create_table "material_transactions", :force => true do |t|
    t.integer  "material_id",                  :null => false
    t.integer  "unit_id"
    t.integer  "setup_id"
    t.float    "rate"
    t.integer  "cents"
    t.integer  "material_transaction_type_id"
    t.datetime "transaction_datetime"
  end

  create_table "material_types", :force => true do |t|
    t.string "name"
  end

  create_table "materials", :force => true do |t|
    t.string  "name"
    t.integer "operation_type_id"
    t.integer "material_type_id"
    t.float   "n_content"
    t.float   "p_content"
    t.float   "k_content"
    t.float   "specific_weight",   :default => 1.0
    t.boolean "liquid"
    t.integer "company_id"
    t.boolean "archived"
  end

  create_table "observation_types", :force => true do |t|
    t.string "name"
  end

  create_table "observation_types_observations", :id => false, :force => true do |t|
    t.integer "observation_id"
    t.integer "observation_type_id"
  end

  create_table "observations", :force => true do |t|
    t.integer "person_id"
    t.text    "comment"
    t.date    "obs_date"
    t.date    "created_on"
    t.string  "state"
    t.integer "company_id"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "given_name"
    t.string   "sur_name"
    t.string   "openid_identifier"
    t.string   "password_salt"
    t.datetime "last_request_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.integer  "company_id"
    t.boolean  "archived"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "setups", :force => true do |t|
    t.integer "activity_id"
    t.integer "equipment_id"
    t.string  "settings"
  end

  create_table "studies", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "treatments", :force => true do |t|
    t.string  "name"
    t.integer "study_id"
    t.integer "treatment_number"
  end

  create_table "units", :force => true do |t|
    t.string  "name"
    t.integer "si_unit_id"
    t.float   "conversion_factor"
  end

end
