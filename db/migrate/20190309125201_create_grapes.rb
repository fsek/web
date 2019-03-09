class CreateGrapes < ActiveRecord::Migration[5.0]
  def change
    create_table :grapes do |t|
      t.string :name, null: false
      t.string :color, null: false

      t.timestamps null: false
    end

    remove_column(:wines, :grape)
    add_reference(:wines, :grape, null: false, foreign_key: true)
  end
end
