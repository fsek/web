class AddServiceToCarRent < ActiveRecord::Migration
  def change
    add_column :rents,:service,:boolean
    change_column :rents, :status,:string, :default => "Ej bestämd"
  end
end
