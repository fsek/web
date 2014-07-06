# encoding:UTF-8
class CalendarController < ApplicationController
    include TheRole::Controller
    
    before_filter :login_required, only: [:show,:index]
    before_filter :authenticate_user!, only: [:show,:index]

    
      def index
      end  
    
      
      def export
        @events = Event.all
        format.ics
      end
      
      
      
      end
