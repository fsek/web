class CreateToolRentings < ActiveRecord::Migration
  def change
    create_table :tool_rentings do |t|
      t.string :renter, index: true, null: false
      t.string :purpose
      t.belongs_to :tool, index: true, null: false
      t.date :return_date, null: false
      t.boolean :returned, default: false
      t.timestamps null: false
    end
  end
end
