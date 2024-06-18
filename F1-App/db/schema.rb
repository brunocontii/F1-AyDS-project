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

ActiveRecord::Schema[7.1].define(version: 2024_05_11_202132) do
  create_table "answers", force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "user_id", null: false
    t.integer "option_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "gamemodes", force: :cascade do |t|
    t.string "name"
    t.integer "progress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", force: :cascade do |t|
    t.text "name_option"
    t.integer "question_id", null: false
    t.boolean "correct", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "lastName"
    t.text "description"
    t.integer "age"
    t.string "profile_picture"
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "name_question"
    t.string "level"
    t.string "theme"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.integer "cant_life"
    t.integer "cant_coins"
    t.datetime "last_life_lost_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "answers", "options"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "profiles", "users"
end
