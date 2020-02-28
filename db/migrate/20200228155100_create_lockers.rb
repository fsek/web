class CreateLockers < ActiveRecord::Migration[5.0]
  def change
    create_table :lockers do |t|
      t.string :name, null: false
      t.string :room, null: false
      t.boolean :occupied, default: false
    end
    create_table :locker_renters do |t|
      t.references :user
      t.references :locker
      t.string :semester, null: false
      t.boolean :payed_for, default: false
      t.boolean :reserved, default: false
    end
    create_table :queued_renters do |t|
      t.references :user
      t.string :semester, null: false
    end
  end
end
