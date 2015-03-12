namespace :paperclip do

  desc "Create a storage folder for Paperclip attachment in shared path"
  task :create_storage do
    run "mkdir -p #{shared_path}/storage"
  end
  
  desc "Link the Paperclip storage folder into the current release"
  task :link_storage do
    run "ln -nfs #{shared_path}/storage #{release_path}/storage"
  end

end

before "deploy:setup", 'paperclip:create_storage'
after "deploy:update_code", "paperclip:link_storage"

# Symlink the database
after 'deploy:update_code', 'deploy:symlink_db'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end
