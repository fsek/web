class ChangeContacts < ActiveRecord::Migration
  def change
    add_column(:contacts, :avatar, :string)
  end
end
