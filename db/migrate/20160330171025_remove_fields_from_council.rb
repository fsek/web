class RemoveFieldsFromCouncil < ActiveRecord::Migration
  def change
    remove_column :councils, :public, :boolean
    remove_column :councils, :logo_file_name, :string
    remove_column :councils, :logo_content_type, :string
    remove_column :councils, :logo_file_size, :integer
    remove_column :councils, :contact_id, :integer
    remove_column :councils, :vicepresident_id, :integer
    remove_column :councils, :logo_updated_at, :datetime

    add_index :councils, :url
    add_index :councils, :president_id
  end
end
