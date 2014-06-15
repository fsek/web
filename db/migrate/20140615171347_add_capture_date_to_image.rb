class AddCaptureDateToImage < ActiveRecord::Migration
  def change
    add_column :images, :captured, :datetime
  end
end
