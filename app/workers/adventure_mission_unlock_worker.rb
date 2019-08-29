class AdventureMissionUnlockWorker
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing, unique_expiration: 60 * 24

  def perform(adventure_id)
    adventure = Adventure.find(adventure_id)
    # Check if this is the correct worker by comparing the adventure start date with the time now.
    # +- 5 seconds in case worker is too quick
    if adventure.start_date.between?(Time.now - 5.seconds, Time.now + 5.seconds)
      AdventureService.lock_adventure_missions(adventure, false)
    end
  end
end
