class CoffeeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :coffee_cards do |t|
      t.references :user
      t.integer :available_coffees, null: false, default: 20
      t.timestamps
    end
  end
end
