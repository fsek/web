class Api::CoffeeCardsController < Api::BaseController
    load_permissions_and_authorize_resource
  
    def index
      @coffee_card = CoffeeCard.all
      render json: @coffee_card, each_serializer: Api::CoffeeCardSerializer::Index
    end

    def purchase_coffees
        coffee_card = CoffeeCard.find(params[:id])
        coffee_card.update(available_coffees: coffee_card.available_coffees - 1)
        render json: {}
    end
  end