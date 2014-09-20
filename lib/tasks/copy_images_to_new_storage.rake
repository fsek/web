namespace :paperclip do
  desc "Copy images to hash path"
  task :move_images => :environment do
    @albums = Album.all
    @albums.each do |album|
      album.images.each do |image| 
        unless image.foto_file_name.blank?
          filename = Rails.root.join('public', 'system', 'images','album', album.id.to_s,image.id.to_s, 'original', image.foto_file_name)   
          if File.exists? filename
            foto = File.new filename
            image.foto = foto
            image.save
            image.foto.reprocess!
            foto.close
          end
        end
      end
    end
  end
end