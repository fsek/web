source 'https://rubygems.org'

gem 'rails', '4.1.1'

gem 'coffee-rails', '~> 4.0.0'
gem 'devise'
gem 'fancybox2-rails', '~> 0.2.8'
gem 'font-awesome-rails'
gem 'fullcalendar-rails', '~>2.1.1'
gem 'icalendar'
gem 'jbuilder', '~> 1.2'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'momentjs-rails'
gem 'mysql2'
gem 'paperclip', "~> 4.1"
gem 'sass-rails', '~> 4.0.3'
gem 'sqlite3'
gem 'the_role', github: 'TheRole/TheRoleApi', tag: 'v2.6'
gem 'the_role_bootstrap3_ui'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'wice_grid', '3.4.2'
gem 'gretel' # Used for breadcrumbs

group :production do
	gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'mailcatcher'
  gem 'quiet_assets'
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

