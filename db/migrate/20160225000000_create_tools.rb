class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :total, default: 1
      t.timestamps null: false
    end
  end
end
