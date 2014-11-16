class CreateCarRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.datetime "from"
      t.datetime "til"        
      t.string   "name"
      t.string   "lastname"
      t.string "email"
      t.string "phone"
      t.text     "purpose"
      t.boolean   "disclaimer"      
      t.boolean  "confirmed"      
      t.integer "council_id" 
      t.timestamps
    end
  end
end
