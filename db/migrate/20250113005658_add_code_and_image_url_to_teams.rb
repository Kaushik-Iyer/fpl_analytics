class AddCodeAndImageUrlToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :image_url, :string
  end
end
