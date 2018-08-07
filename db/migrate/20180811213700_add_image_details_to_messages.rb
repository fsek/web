class AddImageDetailsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :image_details, :json
  end
end
