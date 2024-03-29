class CreateGameScore < ActiveRecord::Migration[5.1]
  def change
    create_table :game_scores do |t|
      t.references :user, foreign_key: true, unique: true, null: false
      t.integer :score, null: false
      
      t.timestamps
    end
  end
end
