class Api::MooseGameScoresController < Api::BaseController
  load_permissions_and_authorize_resource
  
  def index
    scores = MooseGameScore.order(score: :desc).all
    render json: scores, each_serializer: Api::MooseGameScoreSerializer::Index
  end

  def create
    score_entry = MooseGameScore.where(user: current_user).first
    
    if current_user.moose_game_nickname.nil?
      render json: { success: false, message: "Cannot create/update score for user without a game nickname"}, status: 400
      return
    end
    
    if score_entry
      # If already exists, edit
      score_entry.score = params[:score]
      
      if score_entry.save
        render json: { success: true, message: "Updated existing score entry" }
      else 
        render json: { message: "Could not edit existing score" }, status: 400
      end
    else
      #If no user has no score, create it
      if MooseGameScore.create(user: current_user, score: params[:score]).save
        render json: {
          success: true, message: "Created new score entry"
        }, status: :ok
      else
        render json: { errors: 'Failed to create highscore' }, status: 422
      end
    end
    
  end
end