class ChangeFieldsOnPage < ActiveRecord::Migration
  def change
    add_column :page_elements, :element_type, :string, default: :text, null: false
    add_column :page_elements, :page_image_id, :integer, index: true
    add_column :page_elements, :contact_id, :integer, index: true

    rename_column :page_elements, :displayIndex, :index
    change_column_default :page_elements, :index, 1
    change_column_default :page_elements, :visible, true

    remove_column :page_elements, :pictureR, :boolean
    remove_column :page_elements, :border, :boolean
    remove_column :page_elements, :picture_file_name, :string
    remove_column :page_elements, :picture_file_size, :integer
    remove_column :page_elements, :picture_content_type, :string
    remove_column :page_elements, :picture_updated_at, :datetime

    add_index :page_elements, :page_id

    add_column :pages, :public, :boolean, default: true, null: false
    remove_column :pages, :namespace, :string
  end
end
