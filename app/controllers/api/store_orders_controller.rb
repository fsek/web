class Api::StoreOrdersController < Api::BaseController
  def create
    if params.include?('item')
      if params['item'].include?('id')
        if params['item'].include?('quantity')
          render json: { success: 'POST request was successful, good job!' }, status: 200
        else
          render json: { error: 'Missing quantity' }, status: 422
        end
      else
        render json: { error: 'Missing ID' }, status: 422
      end
    else
      render json: { error: 'Missing item' }, status: 422
    end
  end
end
