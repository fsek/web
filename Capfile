# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rbenv'
set :rbenv_type, :user # or :system, depends on your rbenv setup

# Do not forget to update in .ruby-version, circle.yml and Gemfile
set :rbenv_ruby, '2.5.0'

require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'capistrano/sitemap_generator'
require 'rollbar/capistrano3'
require 'capistrano/scm/git'
    install_plugin Capistrano::SCM::Git

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
