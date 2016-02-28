class ChangeFieldOnNotice < ActiveRecord::Migration
  def up
    change_column :notices, :d_publish, :datetime
    change_column :notices, :d_remove, :datetime
    add_column :notices, :user_id, :integer, index: true, null: false

    rename_column :notices, :image_file_name, :image
    remove_column :notices, :image_content_type, :string
    remove_column :notices, :image_file_size, :integer
    remove_column :notices, :image_updated_at, :datetime
  end

  def down
    change_column :notices, :d_publish, :date
    change_column :notices, :d_remove, :date
    remove_column :notices, :user_id, :integer

    rename_column :notices, :image, :image_file_name
    add_column :notices, :image_content_type, :string
    add_column :notices, :image_file_size, :integer
    add_column :notices, :image_updated_at, :datetime
  end
end
