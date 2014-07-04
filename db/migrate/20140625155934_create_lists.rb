class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|

      t.string :category
      t.string :name
      t.string :string1
      t.integer :int1
      t.boolean :bool1
      t.timestamps
      
    end
  end
end
