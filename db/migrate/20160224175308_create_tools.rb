class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :title
      t.text :description
      t.integer :rents, default: 0
      t.integer :total
      t.timestamps null: false
    end
  end
end
