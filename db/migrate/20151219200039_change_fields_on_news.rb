class ChangeFieldsOnNews < ActiveRecord::Migration
  def change
    add_column :news, :url, :string
    remove_column :news, :front_page, :boolean

    add_column :news, :image, :string
    remove_column :news, :image_file_name, :string
    remove_column :news, :image_content_type, :string
    remove_column :news, :image_file_size, :integer
    remove_column :news, :image_updated_at, :datetime
  end
end
