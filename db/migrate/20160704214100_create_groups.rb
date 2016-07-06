class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :number
      t.references :introduction, index: true, foreign_key: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
