class Admin::CoffeeCardsController < Admin::BaseController
    load_permissions_and_authorize_resource

    def index
      @coffee_cards = initialize_grid(CoffeeCard)
    end
  
    def create
      @coffee_card = CoffeeCard.new(coffee_card_params)
      if @coffee_card.save
        redirect_to admin_coffee_cards_path, notice: alert_create(CoffeeCard)
      else
        render :new, status: 422
      end
    end
  
    def update
      if @coffee_card.update(coffee_card_params)
        redirect_to(edit_admin_coffee_card_path(@coffee_card), notice: alert_update(CoffeeCard))
      else
        render :edit, status: 422
      end
    end
  
    def destroy
      @coffee_card.destroy!
      redirect_to(admin_coffee_cards_path, notice: alert_destroy(CoffeeCard))
    end
  
    private
  
    def coffee_card_params
      params.require(:coffee_card).permit(:user_id, :available_coffees)
    end
  end
  