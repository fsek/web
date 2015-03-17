source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

gem 'coffee-rails', '~> 4.0.0'
gem 'devise'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'fancybox2-rails', '~> 0.2.8'
gem 'font-awesome-rails'
gem 'fullcalendar-rails', '~>2.3.1'
gem 'icalendar'
gem 'jbuilder', '~> 1.2'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'momentjs-rails', "~> 2.9.0bun"
gem 'mysql2'
gem 'paperclip', "~> 4.1"
gem 'sass-rails', '~> 4.0.3'
gem 'sqlite3'

gem 'the_role', '~> 3.0.0'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'wice_grid', '3.4.2'

group :production do
  gem 'therubyracer', platforms: :ruby
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'mailcatcher'
end

group :test do
  gem 'shoulda-matchers', require: false
  #gem 'shoulda-callback-matchers'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: false
end

if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
