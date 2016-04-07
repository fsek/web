class ChangeNameAndNamespacePage < ActiveRecord::Migration
  def change
    add_column :pages, :namespace, :string, index: true
    remove_column :page_elements, :name, :string
  end
end
