class CreateWines < ActiveRecord::Migration[5.0]
  def change
    create_table :wines do |t|
      t.string :name, null: false
      t.integer :year, null: false, default: 1970
      t.string :grape, null: false
      t.text :description
      t.string :alcohol, null: false
    end
  end
end
