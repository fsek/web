class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, null: false
      t.string :slug, null: false, index: true
      t.timestamps null: false
    end
  end
end
