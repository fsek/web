class CreateCarRents < ActiveRecord::Migration
  def change
    create_table :rents do |t|
      t.datetime "d_from"
      t.datetime "d_til"        
      t.string   "name"
      t.string   "lastname"
      t.string "email"
      t.string "phone"
      t.text     "purpose"
      t.boolean   "disclaimer"      
      t.boolean  "confirmed", default: false
      t.boolean  "aktiv", default: true     
      t.integer "council_id" 
      t.integer "profile_id"
      t.timestamps
    end
  end
  def down
	drop_table :rents
  end
end
