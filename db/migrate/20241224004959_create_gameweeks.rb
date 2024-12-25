class CreateGameweeks < ActiveRecord::Migration[7.0]
  def change
    create_table :gameweeks do |t|
      t.string :name
      t.datetime :deadline_time
      t.integer :average_entry_score
      t.boolean :finished
      t.boolean :is_current
      t.boolean :is_next
      t.boolean :is_previous
      t.integer :highest_score
      t.integer :most_selected
      t.integer :most_transferred_in
      t.integer :top_element
      t.integer :transfers_made

      t.timestamps
    end
  end
end
