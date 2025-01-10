class AddEmbeddingToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :embedding, :halfvec, limit: 1536
  end
end
