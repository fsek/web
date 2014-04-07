class CalendarController < ApplicationController
    include TheRole::Controller
    
    before_filter :login_required, only: [:kalender,:new,:show,:edit,:create,:update,:destroy]
    before_filter :authenticate_user!, only: [:kalender,:new,:show,:edit,:create,:update,:destroy]
    before_filter :authenticate_editor_events!, only: [:new,:edit]
    
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    
    
      def cafebokning
       
      end
      def kalender
      @events = Event.all
      end
      def export
        @events = Event.all
        format.ics
      end
      
      def new
        @event = Event.new
      end
      def show        
      end
      def edit
        
      end
      def create
        @event = Event.new(event_params)
        @event.update(author: current_user) 
        respond_to do|format|
          if @event.save
            format.html { redirect_to @event,notice: 'Eventet skapades!'}
            format.json { render action: 'show', status: :created, location: @event }
          else
            format.hrml { render action: 'new'}
            format.json { render json: @event.errors, status: :unprocessable_entity}            
          end
        end
      end
      def update        
        respond_to do|format|
          if @event.update(event_params)            
            format.html { redirect_to @event,notice: 'Eventet uppdaterades!'}
            format.json { head :no_content}
          else
            format.hrml { render action: 'edit'}
            format.json { render json: @event.errors, status: :unprocessable_entity}            
          end
        end
      end
      def destroy
        @event.destroy
        respond_to do |format|
          format.html { redirect_to :kalender }
          format.json { head :no_content }
        end
      end
      
      private
      def set_event
        @event = Event.find(params[:id])
      end
      def event_params
        params.require(:event).permit(:title,:author,:content,:location,:date,:end_date,:dayevent,:category)
      end
end
