class CreateFixtures < ActiveRecord::Migration[7.0]
  def change
    create_table :fixtures do |t|
      t.integer :code
      t.integer :event
      t.boolean :finished
      t.boolean :finished_provisional
      t.datetime :kickoff_time
      t.integer :minutes
      t.boolean :provisional_start_time
      t.boolean :started
      t.integer :team_a
      t.integer :team_a_score
      t.integer :team_h
      t.integer :team_h_score
      t.integer :team_h_difficulty
      t.integer :team_a_difficulty
      t.integer :pulse_id

      t.timestamps
    end
  end
end
