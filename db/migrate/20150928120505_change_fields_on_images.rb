class ChangeFieldsOnImages < ActiveRecord::Migration
  def change
    add_column :images, :file, :string
    add_column :images, :filename, :string
    add_column :images, :photographer_id, :integer
    add_column :images, :photographer_name, :string
    add_column :images, :width, :integer
    add_column :images, :height, :integer
    remove_column :images, :captured, :datetime
    remove_column :images, :foto_file_name, :string
    remove_column :images, :foto_content_type, :string
    remove_column :images, :foto_file_size, :integer
    remove_column :images, :foto_updated_at, :datetime
    remove_column :images, :subcategory_id, :integer
    remove_column :images, :description, :integer

    add_index :images, :file
    add_index :images, :filename
    add_index :images, :photographer_id
    add_index :images, :album_id
  end
end
