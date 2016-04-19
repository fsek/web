class CreateCategorization < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.references :category, index: true, foreign_key: true
      t.string :categorizable_type, null: false, index: true
      t.integer :categorizable_id, null: false, index: true
      t.timestamps null: false
    end
  end
end
