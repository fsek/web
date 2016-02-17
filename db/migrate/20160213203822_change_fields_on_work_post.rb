class ChangeFieldsOnWorkPost < ActiveRecord::Migration
  def change
    remove_column :work_posts, :picture_file_name, :string
    remove_column :work_posts, :picture_file_size, :integer
    remove_column :work_posts, :picture_updated_at, :datetime
    remove_column :work_posts, :picture_content_type, :string
    remove_column :work_posts, :category, :string
    remove_column :work_posts, :row_order, :integer

    rename_column :work_posts, :responsible, :user_id
    rename_column :work_posts, :for, :target_group

    change_column_default :work_posts, :visible, true

    add_column :work_posts, :image, :string
    add_column :work_posts, :field, :string

    add_index :work_posts, :user_id
    add_index :work_posts, :target_group
    add_index :work_posts, :field
  end
end
