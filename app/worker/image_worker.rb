class ImageWorker < ActiveJob::Base
  include ::CarrierWave::Workers::StoreAssetMixin

  def when_not_ready
    retry_job
  end

  def when_not_found
    raise ActiveRecord::RecordNotFound
  end
end
