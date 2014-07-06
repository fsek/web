# encoding:UTF-8
class CalendarController < ApplicationController
    include TheRole::Controller
    
    before_filter :login_required
    before_filter :authenticate_user!
    
      def index
      end  
    
      
      def export
        @events = Event.all
        format.ics
      end
end