class CreatePushDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :push_devices do |t|
      t.string :token, null: false
      t.integer :system, default: 0, null: false
      t.references :user, foreign_key: true, index: true
    end

    add_index :push_devices, [:token, :user_id], unique: true
  end
end
