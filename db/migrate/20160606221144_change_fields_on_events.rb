class ChangeFieldsOnEvents < ActiveRecord::Migration
  def change
    remove_column :events, :user_id, :integer
    remove_column :events, :author, :string
    remove_column :events, :category, :string
    remove_column :events, :image_content_type, :string
    remove_column :events, :image_file_size, :integer
    remove_column :events, :image_updated_at, :datetime
    add_column :events, :question, :string
    add_column :events, :for_members, :boolean, default: false, null: false
  end
end
