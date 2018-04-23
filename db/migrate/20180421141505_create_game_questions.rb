class CreateGameQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :game_questions do |t|
      t.string :question, null: false
      t.string :answer1, null: false
      t.string :answer2, null: false
      t.string :answer3, null: false
      t.integer :correct, null: false

      t.timestamps
    end
  end
end
