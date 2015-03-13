# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Fsek::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
