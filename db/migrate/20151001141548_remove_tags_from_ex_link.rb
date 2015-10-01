class RemoveTagsFromExLink < ActiveRecord::Migration
  def change
    remove_column :ex_links, :tags, :string
  end
end
