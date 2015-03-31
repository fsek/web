class AddFieldsToPage < ActiveRecord::Migration
  def change
    add_column :pages, :url, :string
    add_column :pages, :visible, :boolean
    add_column :pages, :title, :string
    add_index :pages, :url
    add_index :pages, :council_id
  end
end
