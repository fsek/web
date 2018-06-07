# config valid only for Capistrano 3.11.0
lock '3.11.0'

set :application, 'fsek'
set :repo_url, 'https://github.com/fsek/web.git'
set :stages, %w(staging production development)
set :rbenv_path, '$HOME/.rbenv'

set :user, :dirac

set :use_sudo, false
set :bundle_binstubs, nil

# Default value for :linked_files is []
set :linked_files, %w(.rbenv-vars)

# Default value for linked_dirs is []
set :linked_dirs, %w(log tmp vendor/bundle public/system
                     public/uploads storage public/sitemaps)

# Rollbar
set :rollbar_token, ENV['ROLLBAR_TOKEN']
set :rollbar_env, proc { fetch :stage }
set :rollbar_role, proc { :app }

set :pty, true

before 'deploy:started', 'sidekiq:quiet'
after 'deploy:publishing', 'sidekiq:stop'
after 'deploy:published', 'passenger:restart'
after 'deploy:published', 'sitemap:refresh'
after 'deploy:published', 'deploy:permissions:load'
after 'deploy:published', 'sidekiq:start'
