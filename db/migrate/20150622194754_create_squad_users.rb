class CreateSquadUsers < ActiveRecord::Migration
  def change
    create_table :squad_users do |t|
      t.integer :user_id
      t.integer :squad_id
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
