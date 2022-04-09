class CoffeeCardsController < ApplicationController
    load_permissions_and_authorize_resource
  
    def index
        @coffee_cards = initialize_grid(current_user.coffee_cards)
      end
    
      def show
        @coffee_card = CoffeeCard.find(params[:id])
      end
  end
  