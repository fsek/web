# config valid only for Capistrano 3.4.0
lock '3.4.0'

set :application, 'fsek'
set :scm, :git
set :repo_url, 'https://github.com/fsek/web.git'
set :stages, %w(staging production development)
set :rbenv_path, '$HOME/.rbenv'

set :user, :dirac

set :use_sudo, false
set :bundle_binstubs, nil

# Default value for :linked_files is []
set :linked_files, %w{.rbenv-vars}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp vendor/bundle public/system public/uploads storage public/sitemaps}

# Rollbar
set :rollbar_token, ENV['ROLLBAR_TOKEN']
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

after 'deploy:publishing', 'passenger:restart'
after 'deploy:publishing', 'deploy:sitemap:refresh'
after 'deploy:publishing', 'deploy:permissions:load'
