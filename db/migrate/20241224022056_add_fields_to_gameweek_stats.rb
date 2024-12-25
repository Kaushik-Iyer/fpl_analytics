class AddFieldsToGameweekStats < ActiveRecord::Migration[7.0]
  def change
    add_column :gameweek_stats, :opponent_team, :integer
    add_column :gameweek_stats, :transfers_in, :integer
    add_column :gameweek_stats, :transfers_out, :integer
    add_column :gameweek_stats, :transfers_balance, :integer
    add_column :gameweek_stats, :value, :decimal
    add_column :gameweek_stats, :was_home, :boolean
    add_column :gameweek_stats, :total_points, :integer
    add_column :gameweek_stats, :team_h_score, :integer
    add_column :gameweek_stats, :team_a_score, :integer
    add_column :gameweek_stats, :kickoff_time, :datetime
  end
end
