class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string "location"
      t.integer "index"
      t.string "link"
      t.string "name"
      t.boolean "visible"
      t.boolean "turbolinks", default: true
      t.boolean "blank_p"
      t.timestamps
    end
  end
end
