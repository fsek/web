class ImageWorker < ActiveJob::Base
  include ::CarrierWave::Workers::StoreAssetMixin

  def when_not_ready
    retry_job
  end
end
