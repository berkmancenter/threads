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

ActiveRecord::Schema.define(version: 2019_04_11_122907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instances", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.text "title", null: false
    t.boolean "closed", null: false
    t.boolean "private", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.index ["owner_id"], name: "index_instances_on_owner_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "moderatorships", id: :serial, force: :cascade do |t|
    t.integer "instance_id"
    t.integer "user_id"
    t.index ["instance_id"], name: "index_moderatorships_on_instance_id"
    t.index ["user_id"], name: "index_moderatorships_on_user_id"
  end

  create_table "muted_room_users", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.index ["room_id"], name: "index_muted_room_users_on_room_id"
    t.index ["user_id"], name: "index_muted_room_users_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "roles_users", id: :serial, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "room_user_nicknames", id: :serial, force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.string "nickname"
    t.index ["room_id", "nickname"], name: "index_room_user_nicknames_on_room_id_and_nickname", unique: true
    t.index ["room_id"], name: "index_room_user_nicknames_on_room_id"
    t.index ["user_id"], name: "index_room_user_nicknames_on_user_id"
  end

  create_table "room_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.integer "last_read_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_read_message_id"], name: "index_room_users_on_last_read_message_id"
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id", "room_id"], name: "index_room_users_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_room_users_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.integer "room_icon_id"
    t.text "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "instance_id"
    t.boolean "locked", default: false
    t.datetime "planned_lock"
    t.index ["instance_id"], name: "index_rooms_on_instance_id"
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
    t.index ["room_icon_id"], name: "index_rooms_on_room_icon_id"
    t.index ["title", "instance_id"], name: "index_rooms_on_title_and_instance_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.integer "avatar_id"
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["avatar_id"], name: "index_users_on_avatar_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
