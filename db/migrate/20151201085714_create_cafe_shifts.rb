class CreateCafeShifts < ActiveRecord::Migration
  def change
    create_table :cafe_shifts do |t|
      t.datetime :start, null: false
      t.integer :pass, null: false
      t.integer :lp, null: false
      t.integer :lv, null: false
    end
  end
end
