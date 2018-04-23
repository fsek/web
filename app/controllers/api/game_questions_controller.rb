class Api::GameQuestionsController < Api::BaseController
  load_permissions_and_authorize_resource

  def new
    @game_question = GameQuestion.first

    render json: @game_question, serializer: Api::GameQuestionSerializer
  end

  def create
    @current_question = GameQuestion.find(params[:question_id])
    result = GameService.check(@current_question, params[:answer], current_user)

    if result[state] == :correct
      render json: result[:next], serializer: Api::GameQuestionSerializer
    else
      render json: result
    end
  end
end
