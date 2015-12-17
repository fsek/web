class CreateCafeWorkers < ActiveRecord::Migration
  def change
    create_table :cafe_workers do |t|
      t.integer :user_id, index: true, null: false
      t.integer :cafe_shift_id, index: true, null: false
      t.boolean :competition, default: true
      t.timestamps null: false
    end
  end
end
