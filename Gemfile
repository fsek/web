source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'coffee-rails'
# Set to 1.8 due to https://github.com/jashkenas/coffeescript/issues/3829
gem 'coffee-script-source', '1.8.0'
gem 'devise'
gem 'fancybox2-rails'
gem 'font-awesome-rails'
gem 'fullcalendar-rails'
gem 'icalendar'
gem 'jbuilder'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'mysql2'
gem 'paperclip'
gem 'responders', '~> 2.0'
gem 'sass-rails'
gem 'sqlite3'
gem 'the_role', github: 'TheRole/TheRoleApi', tag: 'v2.6'
gem 'the_role_bootstrap3_ui'
gem 'turbolinks'
gem 'uglifier'
gem 'wice_grid'

group :production do
	gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'mailcatcher'
  gem 'capybara'
  gem 'poltergeist'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: false
end

if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

