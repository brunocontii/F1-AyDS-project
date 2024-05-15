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
    t.text "text"
  end

  create_table "buys", force: :cascade do |t|
    t.integer "cant_coins_spent"
  end

  create_table "frees", force: :cascade do |t|
    t.string "name_level"
  end

  create_table "gamemodes", force: :cascade do |t|
    t.string "name"
    t.integer "progress"
  end

  create_table "options", force: :cascade do |t|
    t.text "text"
    t.integer "id_o"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "lastName"
    t.text "description"
    t.integer "age"
  end

  create_table "progressives", force: :cascade do |t|
    t.string "name_theme"
  end

  create_table "questions", force: :cascade do |t|
    t.string "name_question"
    t.integer "id_q"
    t.string "level"
    t.string "theme"
  end

  create_table "replies", force: :cascade do |t|
    t.integer "cant_coins_won"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.integer "cant_life"
    t.integer "cant_coins"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wildcards", force: :cascade do |t|
    t.string "name"
    t.integer "cost"
  end

end
