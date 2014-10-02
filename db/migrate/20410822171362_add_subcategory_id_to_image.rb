class AddSubcategoryIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :subcategory_id, :integer
  end
end
