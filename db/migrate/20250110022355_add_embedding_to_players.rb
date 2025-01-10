class AddEmbeddingToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :embedding, :vector, limit: 1536
  end
end
