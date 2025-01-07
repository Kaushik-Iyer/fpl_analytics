class ChangePointsToIntegerInTeams < ActiveRecord::Migration[7.0]
  def change
    change_column :teams, :points, 'integer USING CAST(points AS integer)'
  end
end
