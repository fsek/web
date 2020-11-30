class Admin::FruitsController < Admin::BaseController
	load_permissions_and_authorize_resource

	def index
		@fruits = initialize_grid(Fruit)
	end

	def new
		@fruit = Fruit.new
	end

	def create
		@fruit = Fruit.new(fruit_params)
		if @fruit.save
			redirect_to(admin_fruits_path, notice: alert_create(Fruit))
		else 
			render :new, status: 422
		end
	end

	def update
		if @fruit.update(fruit_params)
			redirect_to(edit_admin_fruit_path(@fruit), notice: alert_update(Fruit))
		else
			render :edit, status: 422
		end
	end

	def destroy
		@fruit.destroy!

		redirect_to(admin_fruits_path, notice: alert_destroy(Fruit))
	end

	private

	def fruit_params
		params.require(:fruit).permit(:name, :isMoldy, :user_id)
	end

end
