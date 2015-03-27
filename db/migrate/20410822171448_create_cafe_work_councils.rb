class CreateCafeWorkCouncils < ActiveRecord::Migration
  def change
    create_table :cafe_work_councils do |t|
      t.integer :cafe_work_id
      t.integer :council_id
      t.timestamps null: false
    end
  end
end
