class CreateWines < ActiveRecord::Migration[5.0]
  def change
    create_table :wines do |t|
      t.string :name, null: false
      t.integer :year, null: false, default: 1937
      t.string :grape, null: false
      t.text :description
    end
  end
end
