class RemoveDisclaimerFromRents < ActiveRecord::Migration
  def change
    remove_column :rents, :disclaimer, :boolean
    remove_column :rents, :name, :string
    remove_column :rents, :access_code, :string
  end
end
