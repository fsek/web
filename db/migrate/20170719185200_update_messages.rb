class UpdateMessages < ActiveRecord::Migration[5.0]
  def change
    add_column(:messages, :sent_at, :integer, null: false, limit: 6, index: true)
  end
end
