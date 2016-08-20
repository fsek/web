source 'https://rubygems.org'

# Do not forget to update in .ruby-version, Capfile and circle.yml
ruby '2.3.0'

gem 'rails', '4.2.6'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'cancancan'
# Need to use this for multiple file upload
# https://github.com/carrierwaveuploader/carrierwave#multiple-file-uploads
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'cookies_eu'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'devise'
gem 'fancybox2-rails'
gem 'font-awesome-rails'
gem 'fotoramajs'
gem 'fullcalendar-rails'
gem 'globalize', '~> 5.0.0'
gem 'globalize-accessors'
gem 'icalendar'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'meta-tags'
gem 'mini_magick'
gem 'momentjs-rails'
gem 'mysql2', '~> 0.3.20' # Rails 4 compatibility
gem 'paperclip'
gem 'pagedown-bootstrap-rails'
gem 'paranoia'
gem 'prawn-rails'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'redcarpet'
gem 'roadie-rails', '~> 1.0'
gem 'rollbar'
gem 'routing-filter', '~> 0.5.1'
gem 'sass-rails'
gem 'select2-rails'
gem 'simple_form'
gem 'sitemap_generator'
gem 'turbolinks'
gem 'uglifier'
# Introduces feature needed in tables, no errors when updating
gem 'wice_grid', '3.6.0.pre4'

# Only enable for a short period to find N+1 in production
gem 'bullet'

# To have a working JVM on server
group :staging, :production do
  gem 'therubyracer', platform: :ruby
end

group :development, :test do
  gem 'better_errors'
  gem 'capistrano', require: false
  # Need 1.1.3 to load sprockets manifest file
  gem 'capistrano-rails', '~> 1.1.3', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-passenger', require: false
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'i18n-tasks'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-example_steps'
  gem 'rspec-rails'
end

group :development do
  gem 'bullet'
  gem 'onesky-rails'
  gem 'quiet_assets'
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
