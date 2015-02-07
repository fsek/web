class CreateCafeWorks < ActiveRecord::Migration
  def change
    create_table :cafe_works do |t|
      t.date    :work_day
      t.integer :pass
      t.integer :profile_id
      t.integer :council_id
      t.string  :name
      t.string  :lastname
      t.string  :phone
      t.string  :stil_id
      t.integer :c_year
      t.integer :lp

      t.timestamps
    end
  end
end
