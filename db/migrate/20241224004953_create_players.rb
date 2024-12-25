class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :second_name
      t.string :web_name
      t.references :team, null: false, foreign_key: true
      t.integer :element_type
      t.decimal :now_cost
      t.integer :total_points
      t.integer :goals_scored
      t.integer :assists
      t.integer :clean_sheets
      t.integer :minutes
      t.string :status
      t.string :news
      t.datetime :news_added
      t.float :form
      t.float :points_per_game
      t.float :selected_by_percent

      t.timestamps
    end
  end
end
