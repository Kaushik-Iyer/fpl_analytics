class CreateChips < ActiveRecord::Migration[7.0]
  def change
    create_table :chips do |t|
      t.string :name
      t.string :chip_type
      t.integer :start_event
      t.integer :stop_event
      t.timestamps
    end
  end
end
