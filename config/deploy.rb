# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'fsek'
set :scm, :git
set :repo_url, 'https://github.com/fsek/web.git'
set :stages, %w(staging production development)

set :user, :dirac

set :format, :petty


# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp vendor/bundle public/system storage}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :deploy, 'permissions:load'
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
