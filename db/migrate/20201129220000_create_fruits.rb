class CreateFruits < ActiveRecord::Migration[5.0]
  def change
    create_table :fruits do |t|
      t.references :user
      t.string :name, null: false
      t.boolean :isMoldy, null: false, default: false
    end
  end
end
