class CreateGameHighscore < ActiveRecord::Migration[5.0]
  def change
    create_table :game_highscores do |t|
      t.references :user, foreign_key: true, null: false, unqiue: true
      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
