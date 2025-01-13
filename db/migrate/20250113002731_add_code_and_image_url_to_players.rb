class AddCodeAndImageUrlToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :code, :integer
    add_column :players, :image_url, :string
  end
end
