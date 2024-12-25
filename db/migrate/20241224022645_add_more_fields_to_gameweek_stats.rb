class AddMoreFieldsToGameweekStats < ActiveRecord::Migration[7.0]
  def change
    add_column :gameweek_stats, :bps, :integer
    add_column :gameweek_stats, :expected_goals, :float
    add_column :gameweek_stats, :expected_assists, :float
    add_column :gameweek_stats, :expected_goal_involvements, :float
    add_column :gameweek_stats, :expected_goals_conceded, :float
    add_column :gameweek_stats, :yellow_cards, :integer
    add_column :gameweek_stats, :red_cards, :integer
    add_column :gameweek_stats, :saves, :integer
    add_column :gameweek_stats, :penalties_saved, :integer
    add_column :gameweek_stats, :penalties_missed, :integer
    add_column :gameweek_stats, :own_goals, :integer
    add_column :gameweek_stats, :starts, :integer
  end
end
