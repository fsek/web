# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'fsek'

# Repo details
set :scm, :git
set :repo_url, 'git@github.com:fsek/web.git'

set :deploy_to, 'home/deploy/fsek'

# Setup rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{storage bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  before :deploy, 'deploy:run_tests'
  after :deploy, 'permissions:load'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
