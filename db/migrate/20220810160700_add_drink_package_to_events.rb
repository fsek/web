class AddDrinkPackageToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :drink_package, :boolean
  end
end
