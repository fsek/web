class CreateExLinks < ActiveRecord::Migration
  def change
    create_table :ex_links do |t|
      t.string :label
      t.text :url
      t.string :tags
      t.boolean :test_availability
      t.text :note
      t.boolean :active
      t.date :expiration

      t.timestamps null: false
    end
  end
end
