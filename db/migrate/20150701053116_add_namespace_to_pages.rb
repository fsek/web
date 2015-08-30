class AddNamespaceToPages < ActiveRecord::Migration
  def change
    add_column :pages, :namespace, :string
  end
end
