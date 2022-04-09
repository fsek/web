class CoffeeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :coffee_cards do |t|
      t.references :user, null: false
      t.integer :available_coffees
      t.timestamps null:false
    end
  end
end
