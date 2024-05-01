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

ActiveRecord::Schema[7.1].define(version: 2024_04_27_190904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

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

  create_table "cars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "make"
    t.string "model"
    t.string "color"
    t.integer "capacity"
    t.string "license_plate"
    t.float "mpg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "hike_cars", force: :cascade do |t|
    t.bigint "hike_id", null: false
    t.bigint "car_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_hike_cars_on_car_id"
    t.index ["hike_id"], name: "index_hike_cars_on_hike_id"
  end

  create_table "hike_participants", force: :cascade do |t|
    t.bigint "hike_car_id", null: false
    t.integer "position"
    t.bigint "user_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hike_car_id"], name: "index_hike_participants_on_hike_car_id"
    t.index ["user_id"], name: "index_hike_participants_on_user_id"
  end

  create_table "hikes", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "short_description"
    t.string "hike_type"
    t.date "date"
    t.time "time"
    t.bigint "host_id"
    t.jsonb "stats", default: {}
    t.string "trailhead_address"
    t.string "alltrails_link"
    t.string "suggested_items"
    t.string "driver_compensation_type"
    t.string "notes"
    t.string "status"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_hikes_on_host_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "push_endpoint"
    t.string "push_p256dh"
    t.string "push_auth"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "full_name"
    t.string "email", default: "", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_no"
    t.string "discord"
    t.string "preferred_name"
    t.string "roles", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "waivers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address", null: false
    t.string "user_agent", null: false
    t.integer "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "version"], name: "index_waivers_on_user_id_and_version", unique: true
    t.index ["user_id"], name: "index_waivers_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "users"
  add_foreign_key "hike_cars", "cars"
  add_foreign_key "hike_cars", "hikes"
  add_foreign_key "hike_participants", "hike_cars"
  add_foreign_key "hike_participants", "users"
  add_foreign_key "hikes", "users", column: "host_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "waivers", "users"
end
