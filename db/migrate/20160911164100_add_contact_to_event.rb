class AddContactToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference(:events, :contact, foreign_key: true)
  end
end
