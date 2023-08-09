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

ActiveRecord::Schema.define(version: 2019_12_12_155451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "table_id"
    t.integer "datatype", default: 0
    t.string "items", limit: 255
    t.boolean "filtre", default: false
    t.boolean "obligatoire", default: false
    t.integer "row_order"
    t.integer "operation"
    t.index ["name"], name: "index_fields_on_name"
    t.index ["table_id"], name: "index_fields_on_table_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "logs", force: :cascade do |t|
    t.integer "field_id"
    t.integer "user_id"
    t.string "message", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "record_index"
    t.string "ip", limit: 255
    t.integer "action"
    t.index ["field_id"], name: "index_logs_on_field_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notification", default: false
    t.boolean "lifo", default: false
    t.string "slug"
    t.index ["slug"], name: "index_tables_on_slug", unique: true
  end

  create_table "tables_users", force: :cascade do |t|
    t.integer "table_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_tables_users_on_table_id"
    t.index ["user_id"], name: "index_tables_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 255
  end

  create_table "values", force: :cascade do |t|
    t.integer "field_id"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "record_index"
    t.index ["field_id"], name: "index_values_on_field_id"
    t.index ["record_index"], name: "index_values_on_record_index"
  end

  add_foreign_key "logs", "fields"
  add_foreign_key "logs", "users"
  add_foreign_key "tables_users", "tables"
  add_foreign_key "tables_users", "users"
end
