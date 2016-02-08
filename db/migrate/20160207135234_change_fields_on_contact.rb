class ChangeFieldsOnContact < ActiveRecord::Migration
  def change
    add_column :contacts, :slug, :string
    add_column :contacts, :post_id, :integer
    remove_column :contacts, :council_id, :integer

    add_index :contacts, :slug
    add_index :contacts, :post_id
  end
end
