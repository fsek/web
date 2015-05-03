class AddFirstnameToModels < ActiveRecord::Migration
  def change
    add_column :cafe_works, :firstname, :string
    add_column :candidates, :firstname, :string
    add_column :rents, :firstname, :string
  end
end
