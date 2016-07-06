namespace 'user' do
  desc('Moves the profile pictures to a new structure for carrierwave')
  task(move_avatars: :environment) do
    if File.exists?(File.join(Rails.root, 'storage', 'user'))
      puts 'Rename folder from /user to /users'
      File.rename(File.join(Rails.root, 'storage', 'user'), File.join(Rails.root, 'storage', 'users'))
    end

    storage = File.join(Rails.root, 'storage', 'users')
    Dir.foreach(storage) do |folder|
      next if folder == '.' || folder == '..' || folder == '.DS_Store'

      mv(Dir.glob("#{storage}/#{folder}/original/*.*"), File.join(storage, folder))
      rmdir(File.join(storage, folder, 'original'))
      rm(Dir.glob("#{storage}/#{folder}/medium/*.*"))
      rmdir(File.join(storage, folder, 'medium'))
      rm(Dir.glob("#{storage}/#{folder}/thumb/*.*"))
      rmdir(File.join(storage, folder, 'thumb'))
    end

  end

  desc('Recreates user profile pictures to the new structure')
  task(recreate_avatars: :environment) do
    User.where.not(avatar_file_name: nil).each do |user|
      user.avatar.recreate_versions!
      user.save!
    end
  end
end
