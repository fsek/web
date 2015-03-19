Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(css|js|scss|sass)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    full_path.starts_with? app_assets_path
  else
    false
  end
end
