class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.string :code, null: false
      t.string :strength
      t.string :strength_overall_home
      t.string :strength_overall_away
      t.string :strength_attack_home
      t.string :strength_attack_away
      t.string :strength_defence_home
      t.string :strength_defence_away
      t.string :played
      t.string :points

      t.timestamps
    end
  end
end
