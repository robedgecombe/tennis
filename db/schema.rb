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

ActiveRecord::Schema.define(version: 20150114000655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: true do |t|
    t.integer  "score",      default: 0
    t.integer  "you_id"
    t.integer  "him_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.integer  "match_id"
    t.integer  "energy",                    default: 200
    t.integer  "game_score",                default: 0
    t.integer  "set_score",                 default: 0
    t.integer  "match_score",               default: 0
    t.integer  "opponent_game_score",       default: 0
    t.integer  "opponent_set_score",        default: 0
    t.integer  "opponent_match_score",      default: 0
    t.integer  "advantage_server_points",   default: 0
    t.integer  "advantage_receiver_points", default: 0
    t.integer  "confidence"
    t.integer  "concentration"
    t.integer  "intelligence"
    t.integer  "power"
    t.integer  "speed"
    t.integer  "backhand"
    t.integer  "accuracy"
    t.integer  "net_ability"
    t.integer  "drop_shot"
    t.integer  "first_serve"
    t.integer  "second_serve"
    t.integer  "return"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
