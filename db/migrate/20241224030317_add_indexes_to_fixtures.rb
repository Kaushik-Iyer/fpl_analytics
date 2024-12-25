class AddIndexesToFixtures < ActiveRecord::Migration[7.0]
  def change
    add_index :fixtures, :event
    add_index :fixtures, :team_h
    add_index :fixtures, :team_a
    add_index :fixtures, :kickoff_time
  end
end
