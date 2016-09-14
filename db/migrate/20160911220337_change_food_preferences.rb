class ChangeFoodPreferences < ActiveRecord::Migration
  def change
    rename_column(:users, :food_preference, :food_custom)
    add_column(:users, :food_preferences, :string)
  end
end
