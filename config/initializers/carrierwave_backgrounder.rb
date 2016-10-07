CarrierWave::Backgrounder.configure do |c|
  c.backend :active_job, queue: :carrierwave
end
