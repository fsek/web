class Api::CoffeeCardsController < Api::BaseController
    load_permissions_and_authorize_resource
  
    def index
      @fruits = CoffeeCard.all
      render json: @coffee_cards,
      each_serializer: Api::CoffeeCardSerializer::Index
    end
  
    def show
      @fruit = CoffeeCard.find(params[:id])
      render json: @coffee_card,
      serializer: Api::CoffeeCardSerializer::Show
    end

    def purchase_coffees
        @coffee_card = CoffeeCard.find(params[:id])
        @coffee_card.available_coffees -= 1
    end
  end