class ChangeMeetings < ActiveRecord::Migration[5.0]
  def change
    remove_column(:meetings, :status)
    remove_column(:meetings, :room)
    add_column(:meetings, :status, :integer, default: 0)
    add_column(:meetings, :room, :integer, default: 0)
  end
end
