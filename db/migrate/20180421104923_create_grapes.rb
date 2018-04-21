class CreateGrapes < ActiveRecord::Migration[5.0]
  def change
    create_table :grapes do |t|
      t.string :name, null: false
      t.string :color, null: false

      t.timestamps
    end
  end
end
