class ChangeContacts < ActiveRecord::Migration[5.0]
  def change
    add_column(:contacts, :avatar, :string)
  end
end
