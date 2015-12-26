source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.5'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'cancancan'
# Need to use this for multiple file upload
# https://github.com/carrierwaveuploader/carrierwave#multiple-file-uploads
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'coffee-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'bootstrap-datepicker-rails'
gem 'devise'
gem 'factory_girl_rails'
gem 'fancybox2-rails'
gem 'font-awesome-rails'
gem 'fotoramajs'
gem 'fullcalendar-rails'
gem 'haml-rails'
gem 'icalendar'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'mini_magick'
gem 'momentjs-rails'
gem 'mysql2', '~> 0.3.20' # Rails 4 compatibility
gem 'paperclip'
gem 'prawn-rails'
gem 'quiet_assets'
gem 'responders'
gem 'sass-rails'
gem 'simple_form'
gem 'turbolinks'
gem 'uglifier'
# Introduces feature needed in tables, no errors when updating
gem 'wice_grid', '3.6.0.pre4'

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
  gem 'i18n-tasks'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-example_steps'
  gem 'rspec-rails'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
