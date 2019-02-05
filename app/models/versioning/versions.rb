class Versions
  def self.get(name)
    @versions ||= Rails.application.config_for(:versions)
    @versions[name.to_s]
  end
end
