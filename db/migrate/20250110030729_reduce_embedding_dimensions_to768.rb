class ReduceEmbeddingDimensionsTo768 < ActiveRecord::Migration[7.0]
  def change
    change_column :players, :embedding, :halfvec, limit: 768
    change_column :teams, :embedding, :halfvec, limit: 768
  end
end
