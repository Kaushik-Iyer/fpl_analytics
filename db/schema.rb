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

ActiveRecord::Schema[7.0].define(version: 2024_12_27_012524) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chips", force: :cascade do |t|
    t.string "name"
    t.string "chip_type"
    t.integer "start_event"
    t.integer "stop_event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixtures", force: :cascade do |t|
    t.integer "code"
    t.integer "event"
    t.boolean "finished"
    t.boolean "finished_provisional"
    t.datetime "kickoff_time"
    t.integer "minutes"
    t.boolean "provisional_start_time"
    t.boolean "started"
    t.integer "team_a"
    t.integer "team_a_score"
    t.integer "team_h"
    t.integer "team_h_score"
    t.integer "team_h_difficulty"
    t.integer "team_a_difficulty"
    t.integer "pulse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event"], name: "index_fixtures_on_event"
    t.index ["kickoff_time"], name: "index_fixtures_on_kickoff_time"
    t.index ["team_a"], name: "index_fixtures_on_team_a"
    t.index ["team_h"], name: "index_fixtures_on_team_h"
  end

  create_table "gameweek_stats", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "gameweek_id", null: false
    t.integer "minutes"
    t.integer "goals_scored"
    t.integer "assists"
    t.integer "clean_sheets"
    t.integer "goals_conceded"
    t.integer "bonus"
    t.float "influence"
    t.float "creativity"
    t.float "threat"
    t.float "ict_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "opponent_team"
    t.integer "transfers_in"
    t.integer "transfers_out"
    t.integer "transfers_balance"
    t.decimal "value"
    t.boolean "was_home"
    t.integer "total_points"
    t.integer "team_h_score"
    t.integer "team_a_score"
    t.datetime "kickoff_time"
    t.integer "bps"
    t.float "expected_goals"
    t.float "expected_assists"
    t.float "expected_goal_involvements"
    t.float "expected_goals_conceded"
    t.integer "yellow_cards"
    t.integer "red_cards"
    t.integer "saves"
    t.integer "penalties_saved"
    t.integer "penalties_missed"
    t.integer "own_goals"
    t.integer "starts"
    t.index ["gameweek_id"], name: "index_gameweek_stats_on_gameweek_id"
    t.index ["player_id"], name: "index_gameweek_stats_on_player_id"
  end

  create_table "gameweeks", force: :cascade do |t|
    t.string "name"
    t.datetime "deadline_time"
    t.integer "average_entry_score"
    t.boolean "finished"
    t.boolean "is_current"
    t.boolean "is_next"
    t.boolean "is_previous"
    t.integer "highest_score"
    t.integer "most_selected"
    t.integer "most_transferred_in"
    t.integer "top_element"
    t.integer "transfers_made"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "web_name"
    t.bigint "team_id", null: false
    t.integer "position_id"
    t.decimal "now_cost"
    t.integer "total_points"
    t.integer "goals_scored"
    t.integer "assists"
    t.integer "clean_sheets"
    t.integer "minutes"
    t.string "status"
    t.string "news"
    t.datetime "news_added"
    t.float "form"
    t.float "points_per_game"
    t.float "selected_by_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "plural_name"
    t.string "plural_name_short"
    t.string "singular_name"
    t.string "singular_name_short"
    t.integer "squad_select"
    t.integer "squad_min_select"
    t.integer "squad_max_select"
    t.integer "squad_min_play"
    t.integer "squad_max_play"
    t.boolean "ui_shirt_specific"
    t.json "sub_positions_locked"
    t.integer "element_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", null: false
    t.string "code", null: false
    t.string "strength"
    t.string "strength_overall_home"
    t.string "strength_overall_away"
    t.string "strength_attack_home"
    t.string "strength_attack_away"
    t.string "strength_defence_home"
    t.string "strength_defence_away"
    t.string "played"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "gameweek_stats", "gameweeks"
  add_foreign_key "gameweek_stats", "players"
  add_foreign_key "players", "teams"
end
