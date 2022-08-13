class AddLotteryToEventSignup < ActiveRecord::Migration[5.1]
  def change
    add_column :event_signups, :lottery, :boolean, default: false
  end
end
