class AddImageToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :image, :string
  end
end
