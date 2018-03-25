class CreateAchievementUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :achievement_users do |t|
      t.references :achievement, foreign_key: true, index: true, unique: true
      t.references :user, foreign_key: true, index: true, unique: true
      t.timestamps null: false
    end
  end
end
