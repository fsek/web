class CreateAchievementUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :achievement_users do |t|
      t.references :achievement, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.index [:achievement_id, :user_id], unique: true
      t.timestamps null: false
    end
  end
end
