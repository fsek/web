class CreateMainMenu < ActiveRecord::Migration
  def change
    create_table :main_menus do |t|
      t.string :name
      t.integer :index
      t.boolean :mega, null: false, default: true
      t.boolean :fw, null: false, default: false
      t.timestamps null: false
    end
  end
end
