class CreateKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keys do |t|
      t.string :name, null: false
      t.integer :total, null: false, default: 1
      t.text :description
    end
    create_table :key_users do |t|
      t.references :user
      t.references :key
    end
  end
end
