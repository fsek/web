class ChangeFieldsOnImages < ActiveRecord::Migration
  def change
    add_column :images, :file, :string
    add_column :images, :filename, :string
    remove_column :images, :foto_file_name, :string
    remove_column :images, :foto_content_type, :string
    remove_column :images, :foto_file_size, :integer
    remove_column :images, :foto_updated_at, :datetime

    add_index :images, :file
    add_index :images, :filename
  end
end
