# encoding:UTF-8
class CalendarController < ApplicationController
    include TheRole::Controller
    
    before_filter :login_required,only: :index
    before_filter :authenticate_user!, only: :index
    
      def index
      end  
    
      
      def export
        @events = Event.all
        format.ics
      end
end