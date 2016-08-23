class AddSoftDeleteEvent < ActiveRecord::Migration
  def change
    add_column(:events, :deleted_at, :datetime, index: true)
  end
end
