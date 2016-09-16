class AddContactToEvent < ActiveRecord::Migration
  def change
    add_reference(:events, :contact, foreign_key: true)
  end
end
