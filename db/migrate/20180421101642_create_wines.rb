class CreateWines < ActiveRecord::Migration[5.0]
  def change
    create_table :wines do |t|
      t.string :name, null: false
      t.integer :year, default: 2010, null: false
      t.string :country, null: false

      t.timestamps
    end
  end
end
