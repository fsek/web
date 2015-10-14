# encoding: UTF-8
# To be able to use route helpers inside RSpec-tests
RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
end

# To be able to use t() instead of I18n.t()
RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
end
