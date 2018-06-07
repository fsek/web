source 'https://rubygems.org'

# Do not forget to update in .ruby-version, Capfile and circle.yml
ruby '2.5.0'

gem 'rails', '5.1.6'

gem 'active_model_serializers', '~> 0.10.0'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'cancancan'
gem 'carrierwave', '~> 0.11.2'
gem 'carrierwave_backgrounder', git: 'https://github.com/lardawge/carrierwave_backgrounder'
gem 'cookies_eu'
gem 'datetimepicker-rails', git: 'https://github.com/zpaulovics/datetimepicker-rails',
                            branch: 'master',
                            submodules: true
gem 'devise'
gem 'devise_token_auth'
gem 'ejs'
gem 'font-awesome-rails'
gem 'fotoramajs'
gem 'fullcalendar-rails'
gem 'globalize', git: 'https://github.com/globalize/globalize' # For rails 5.1 support
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'
gem 'icalendar'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'meta-tags'
gem 'mail', '>= 2.6.6.rc1'
gem 'mini_magick'
gem 'momentjs-rails'
gem 'nokogiri', '>=1.7'
gem 'pg'
gem 'paperclip', '>= 5.2.0'
gem 'pagedown-bootstrap-rails'
gem 'paranoia'
gem 'prawn-rails'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'redcarpet'
gem 'redis', '< 4'
gem 'roadie-rails', '~> 1.3'
gem 'rollbar'
gem 'rpush'
gem 'routing-filter', '~> 0.6.0'
gem 'sass-rails'
gem 'select2-rails'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-unique-jobs'
gem 'simple_form'
gem 'sitemap_generator'
gem 'turbolinks'
gem 'uglifier'
gem 'wice_grid', git: 'https://github.com/navro/wice_grid', branch: 'rails51'

# To have a working JVM on server
group :staging, :production do
  gem 'therubyracer', platform: :ruby
end

group :development, :test do
  gem 'better_errors', git: 'https://github.com/charliesome/better_errors' # For rails 5 support
  gem 'capistrano', require: false
  # Need 1.1.3 to load sprockets manifest file
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-passenger', require: false
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'listen'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'puma'
  gem 'rspec-example_steps'
  gem 'rspec-rails'
end

group :development do
  gem 'bullet'
  gem 'foreman'
  gem 'onesky-rails'
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
end
