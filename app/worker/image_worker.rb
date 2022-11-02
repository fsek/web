class ImageWorker < ActiveJob::Base
  include ::CarrierWave::Workers::StoreAssetMixin
  count = 0
  def when_not_ready
    if count < 5
      retry_job
      count += 1
    end
  end
end
