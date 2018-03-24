class CreateAchievements < ActiveRecord::Migration[5.0]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.integer :points, null: false, default: 0
      t.timestamps null: false
    end
  end
end
