class ImageWorker < ActiveJob::Base
  include ::CarrierWave::Workers::StoreAssetMixin

  def when_not_ready
    ## Stop this insanity!
    #retry_job
  end
end
