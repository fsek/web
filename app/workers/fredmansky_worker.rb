class FredmanskyWorker
  include Sidekiq::Worker

  def perform
    PushService.push(FredmanskyData, User.joins(:fredmansky))
  end
end
