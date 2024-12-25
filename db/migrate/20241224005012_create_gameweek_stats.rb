class CreateGameweekStats < ActiveRecord::Migration[7.0]
  def change
    create_table :gameweek_stats do |t|
      t.references :player, null: false, foreign_key: true
      t.references :gameweek, null: false, foreign_key: true
      t.integer :minutes
      t.integer :goals_scored
      t.integer :assists
      t.integer :clean_sheets
      t.integer :goals_conceded
      t.integer :bonus
      t.float :influence
      t.float :creativity
      t.float :threat
      t.float :ict_index

      t.timestamps
    end
  end
end
