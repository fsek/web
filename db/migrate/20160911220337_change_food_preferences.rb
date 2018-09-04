class ChangeFoodPreferences < ActiveRecord::Migration[5.0]
  def change
    rename_column(:users, :food_preference, :food_custom)
    add_column(:users, :food_preferences, :string)
  end
end
