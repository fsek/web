class ToolRentingService
  include Sidekiq::Scheduled

  def self.schedule_reminder(rent)
    ToolRentingReminderWorker.perform_at(Time.parse(rent.return_date.to_s) + 1.days, rent.id)
  end

  def self.remove_reminder(rent)
    scheduled = Sidekiq::ScheduledSet.new.select

    scheduled.map do |job|
      if job.klass == 'ToolRentingReminderWorker'
        if job.args.include? rent.id
          job.delete
        end
      end
    end.compact
  end
end
