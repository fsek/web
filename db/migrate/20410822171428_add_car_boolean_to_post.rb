class AddCarBooleanToPost < ActiveRecord::Migration
  def change
    add_column :posts,:car_rent,:boolean
  end
end
