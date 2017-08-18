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

ActiveRecord::Schema.define(version: 20170521052203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "set_id"
    t.integer  "number"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "server_id"
    t.string   "status",     limit: 255
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "match_sets", force: :cascade do |t|
    t.integer  "match_stats_id",             null: false
    t.integer  "number"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.string   "status",         limit: 255
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "match_stats", force: :cascade do |t|
    t.integer  "match_id",          null: false
    t.integer  "player_1_stats_id", null: false
    t.integer  "player_2_stats_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "matches", force: :cascade do |t|
    t.string   "status",      limit: 255, default: "new"
    t.integer  "player_1_id"
    t.integer  "player_2_id"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "venue_id"
    t.string   "type",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_stats", force: :cascade do |t|
    t.string  "name",          limit: 255
    t.integer "energy",                    default: 200
    t.integer "confidence"
    t.integer "concentration"
    t.integer "intelligence"
    t.integer "power"
    t.integer "speed"
    t.integer "backhand"
    t.integer "accuracy"
    t.integer "net_ability"
    t.integer "drop_shot"
    t.integer "first_serve"
    t.integer "second_serve"
    t.integer "return"
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.integer  "match_id"
    t.integer  "energy",                                default: 200
    t.integer  "game_score",                            default: 0
    t.integer  "set_score",                             default: 0
    t.integer  "match_score",                           default: 0
    t.integer  "opponent_game_score",                   default: 0
    t.integer  "opponent_set_score",                    default: 0
    t.integer  "opponent_match_score",                  default: 0
    t.integer  "advantage_server_points",               default: 0
    t.integer  "advantage_receiver_points",             default: 0
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

  create_table "points", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "tiebreak_id"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "server_id"
    t.string   "status"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "shots", force: :cascade do |t|
    t.integer "hitter_id",                                                                      null: false
    t.integer "receiver_id",                                                                    null: false
    t.integer "point_id",                                                                       null: false
    t.string  "type"
    t.string  "hand"
    t.decimal "x_axis_location_on_contact",             precision: 5, scale: 2
    t.decimal "y_axis_location_on_contact",             precision: 5, scale: 2
    t.decimal "ball_height_on_contact",                 precision: 5, scale: 2
    t.integer "horizontal_ball_direction_on_contact"
    t.integer "vertical_ball_direction_on_contact"
    t.float   "ball_speed_on_contact"
    t.string  "spin_direction_on_contact"
    t.float   "spin_revolutions_per_second_on_contact"
    t.float   "body_position_control_percentage"
    t.float   "racket_sweet_spot_percentage"
    t.float   "energy_towards_spin"
    t.float   "energy_towards_power"
    t.float   "energy_towards_placement"
    t.string  "attempted_location"
    t.string  "attempted_spin_direction"
    t.boolean "good"
    t.boolean "winner",                                                         default: false
  end

  create_table "tiebreaks", force: :cascade do |t|
    t.integer  "set_id"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.string   "status"
    t.datetime "start_time"
    t.datetime "end_time"
  end

end
