class ConvertVectorToHalfvecInPlayers < ActiveRecord::Migration[7.0]
  def change
    change_column :players, :embedding, :halfvec, limit: 1536
  end
end
