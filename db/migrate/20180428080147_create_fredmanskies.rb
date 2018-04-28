class CreateFredmanskies < ActiveRecord::Migration[5.0]
  def change
    create_table :fredmanskies do |t|
      t.references :user, foreign_key: true, unique: true, null: false

      t.timestamps
    end
  end
end
