class AddFoodPreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :food_preference, :string
  end
end
