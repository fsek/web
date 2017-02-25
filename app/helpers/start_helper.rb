module StartHelper
  def weektorn_signup
    I18n.locale == :en ? weektorn_signup_path : vecktorn_signup_path
  end

  def weektorn_archive
    I18n.locale == :en ? weektorn_archive_path : vecktorn_archive_path
  end
end
