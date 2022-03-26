class AddBloodfeudToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :donated, :boolean, default: false
    add_column :users, :donation_confirmed, :boolean, default: false
  end
end
