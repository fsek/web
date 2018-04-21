class UpdateWines < ActiveRecord::Migration[5.0]
  def change
    add_reference(:wines, :grape, index: true, null: false)
  end
end
