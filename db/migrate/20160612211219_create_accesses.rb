class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.references :door, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
