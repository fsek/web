class Api::RentsController < Api::BaseController
  load_permissions_and_authorize_resource
  def index
    render json: Rent.all.as_json()
  end
  def show
    rent = Rent.find(params[:id])
    render json: rent, serializer: Api::RentSerializer::Show
  end
  
  def create
    # some magic to build a rent object with user set to nil
    rent = Rent.new(rent_params)
   
    # bool value if terms are accepted or not
    terms = params[:terms]
    # pain
    rent.user = current_user
    # This api end point might need some nice error messaging,
    # since a lot of things can go wrong when trying to create
    # a reservation

    # ok this is very weird. RentService.reservation overwrites
    # the user with current_user, but validates before then.
    # It also overwrites terms, but validates before then. 
    # This seems seriously problematic. Ask Lukas.
    if RentService.reservation(current_user, rent, terms)
      render json: {}, status: :ok
    else
      render json: {errors: rent.errors.full_messages }, status: 422
    end
  end

  def destroy
    rent = Rent.find(params[:id])
    if rent.destroy!
      render json: {}, status: :ok
    else
      render json: { errors: 'Failed to destroy' }, status: 422
    end
  end

  def update
    rent = Rent.find(params[:id])
    if RentService.update(rent_params, current_user, rent)
      render json: {}, status: :ok
    else
      render json: { errors: rent.errors.full_messages }, status: 422
    end
  end
  private
  def rent_params
    #d_from, d_til required for update
    params.require(:rent).permit(:d_from, :d_til, :purpose,
                                 :council_id, :user_id, :terms)
  end
end