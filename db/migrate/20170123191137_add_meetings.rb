class AddMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.datetime :start_date, index: true, null: false
      t.datetime :end_date, index: true, null: false
      t.string :status, default: 'unconfirmed', null: false
      t.string :room, null: false
      t.string :title, null: false
      t.text :purpose
      t.text :comment
      t.references :user, index: true, foreign_key: true
      t.references :council, index: true, foreign_key: true
      t.boolean :by_admin, null: false, default: false
    end
  end
end
