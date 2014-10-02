class RemoveSubcategoryIdFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :subcategory_id, :integer
  end
end
