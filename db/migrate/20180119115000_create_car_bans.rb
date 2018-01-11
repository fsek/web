class CreateCarBans < ActiveRecord::Migration[5.0]
  def change
    create_table :car_bans do |t|
      t.references :user, foreign_key: true, index: true, unique: true
      t.references :creator, index: true
      t.text :reason
      t.timestamps null: false
    end

    add_foreign_key :car_bans, :users, column: :creator_id
  end
end
