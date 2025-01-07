class RenameElementTypeToPositionIdInPlayers < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :element_type, :position_id
  end
end
