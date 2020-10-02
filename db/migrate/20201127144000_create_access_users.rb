class CreateAccessUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :access_users do |t|
      t.references :user
      t.references :door
      t.string :purpose, null: false
    end
  end
end
