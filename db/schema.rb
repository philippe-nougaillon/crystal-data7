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

ActiveRecord::Schema[7.0].define(version: 2023_12_21_102601) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "blobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "slug"
    t.integer "visibility", default: 0
    t.index ["name"], name: "index_fields_on_name"
    t.index ["slug"], name: "index_fields_on_slug", unique: true
    t.index ["table_id"], name: "index_fields_on_table_id"
  end

  create_table "filters", force: :cascade do |t|
    t.string "name"
    t.bigint "table_id", null: false
    t.json "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "slug"
    t.index ["table_id"], name: "index_filters_on_table_id"
    t.index ["user_id"], name: "index_filters_on_user_id"
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

  create_table "messages", force: :cascade do |t|
    t.string "nom"
    t.bigint "filter_id", null: false
    t.bigint "field_id", null: false
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["field_id"], name: "index_messages_on_field_id"
    t.index ["filter_id"], name: "index_messages_on_filter_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.bigint "field_id", null: false
    t.integer "table_id"
    t.integer "relation_with_id"
    t.string "items", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_relations_on_field_id"
    t.index ["relation_with_id"], name: "index_relations_on_relation_with_id"
    t.index ["table_id"], name: "index_relations_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notification", default: false
    t.boolean "lifo", default: false
    t.string "slug"
    t.integer "record_index", default: 0, null: false
    t.boolean "show_on_startup_screen", default: false
    t.index ["slug"], name: "index_tables_on_slug", unique: true
  end

  create_table "tables_users", force: :cascade do |t|
    t.integer "table_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["table_id"], name: "index_tables_users_on_table_id"
    t.index ["user_id"], name: "index_tables_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "uid"
    t.string "provider"
    t.string "slug"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "values", force: :cascade do |t|
    t.integer "field_id"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "record_index"
    t.string "old_value"
    t.bigint "user_id", null: false
    t.index ["field_id"], name: "index_values_on_field_id"
    t.index ["record_index"], name: "index_values_on_record_index"
    t.index ["user_id"], name: "index_values_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "filters", "tables"
  add_foreign_key "filters", "users"
  add_foreign_key "logs", "fields"
  add_foreign_key "logs", "users"
  add_foreign_key "messages", "fields"
  add_foreign_key "messages", "filters"
  add_foreign_key "messages", "users"
  add_foreign_key "relations", "fields"
  add_foreign_key "tables_users", "tables"
  add_foreign_key "tables_users", "users"
  add_foreign_key "values", "users"
end
