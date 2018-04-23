module GameService
  def self.check(game_question, answer, current_user)
    correct = game_question.correct?(answer)
    current_id = game_question.id

    if correct && !game_question.last?
      # Fetch the next question, let the game continue!
      { state: :correct, next: GameQuestion.find(current_id + 1) }
    else
      # We have lost OR won, update the highscore
      score = GameHighscore.find_or_initialize_by(user: current_user)
      score.change_if_higher(current_id)
      score.save!

      # Did we win?
      if correct
        { state: :winner }
      else
        { state: :loser }
      end
    end
  end
end
