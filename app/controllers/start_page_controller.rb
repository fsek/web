class StartPageController < ApplicationController
layout "startsida_example"
skip_before_filter :authenticate_user!
add_breadcrumb 'Start',:start_path
add_breadcrumb 'Start',:start_path
def start
  add_breadcrumb 'Start', :start_path
  add_breadcrumb "Utskott",:utskott_path
end
end
