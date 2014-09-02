class RemoveImagesSubcategories < ActiveRecord::Migration
  def change
  drop_table :images_subcategories
  end
end
