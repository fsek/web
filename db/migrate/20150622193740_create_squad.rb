class CreateSquad < ActiveRecord::Migration
  def change
    create_table :squads do |t|
      t.string :title
      t.string :category
      t.text :description
      t.boolean :public

      t.index :title

      t.timestamps null: false
    end
  end
end
