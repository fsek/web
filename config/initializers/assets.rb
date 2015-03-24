Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js|scss|sass)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    full_path.starts_with? app_assets_path
  else
    false
  end
end

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << "#{Rails}/vendor/assets/fonts"

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# For Fullcalendar
Rails.application.config.assets.precompile += ['application-print.css']
