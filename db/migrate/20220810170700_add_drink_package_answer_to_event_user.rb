class AddDrinkPackageAnswerToEventUser < ActiveRecord::Migration[5.1]
  def change
    add_column :event_users, :drink_package_answer, :boolean
  end
end
