class CreateEventSignups < ActiveRecord::Migration
  def change
    create_table :event_signups do |t|
      t.references :event, index: true, foreign_key: true
      t.boolean :for_members, default: true, null: false
      t.string :question
      t.integer :slots
      t.datetime :closes
      t.datetime :opens
      t.integer :novice
      t.integer :mentor
      t.integer :member
      t.integer :custom
      t.string :custom_name
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end

    add_index(:event_signups, :event_id, unique: true,
                                         name: 'event_signups_unique_event_index')
  end
end
