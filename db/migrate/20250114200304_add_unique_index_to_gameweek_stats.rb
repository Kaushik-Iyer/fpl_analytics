class AddUniqueIndexToGameweekStats < ActiveRecord::Migration[7.0]
  def change
    add_index :gameweek_stats, [:player_id, :gameweek_id], unique: true
  end
end
