module EmailHelper
  def inline_css(asset_path)
    if %w(development test).include?(Rails.env.to_s)
      file = Rails.application.assets.find_asset(asset_path)
      file.source if file.present?
    else
      file = find_css_asset(asset_path)
      File.read(File.join(Rails.root, 'public', 'assets', file)) if file.present?
    end
  end

  def find_css_asset(asset_path)
    # Find precompiled asset in production and staging
    file = Rails.application.assets_manifest.assets[asset_path]
    file ||= Rails.application.assets_manifest.
             assets["#{File.basename(asset_path, File.extname(asset_path))}.css"]
    file
  end
end
