class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions do |t|
      t.string :plural_name
      t.string :plural_name_short
      t.string :singular_name
      t.string :singular_name_short
      t.integer :squad_select
      t.integer :squad_min_select
      t.integer :squad_max_select
      t.integer :squad_min_play
      t.integer :squad_max_play
      t.boolean :ui_shirt_specific
      t.json :sub_positions_locked
      t.integer :element_count

      t.timestamps
    end
  end
end
