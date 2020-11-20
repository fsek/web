class ToolRentingReminderWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(rent_id)
    rent = ToolRenting.find(rent_id)

    unless rent.nil? || rent.returned
      ToolRentingMailer.send_reminder_email(rent).deliver_now
    end
  end
end
