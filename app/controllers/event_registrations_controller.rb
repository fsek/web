# encoding:UTF-8
class EventRegistrationsController < ApplicationController
  
    before_action :login_required
		before_action :is_registrable, only: [:index, :new, :create]
		before_action :authenticate_admin, only: :event_index
    before_action :authenticate, only: [:edit,:update,:show,:destroy]
		before_action :authenticate_user, only: :profile_index
    before_action :set_event_registration, only: [:show,:edit,:update,:destroy]
    before_action :set_event, only: [:destroy, :new,:create, :edit, :index, :update]

	def index
		@text = ""
		@reserved = EventRegistration.where(event_id: params[:event_id]).count
		@new = nil
		@event_registration = EventRegistration.where(profile_id: current_user.profile.id, event_id: params[:event_id]).first
		if @event_registration.nil?
			@new = 1
			@event_registration = EventRegistration.new
		end
		if !@new && @event_registration.reserve_spot
			@text =	"- Du ligger som reserv för eventet."
		elsif !@new && !@event_registration.reserve_spot 
			@text =	"- Du är anmäld till eventet."
		end
    respond_to do |format|
      format.html { render }
      format.json { render :json => @event_registrations }
    end
	end
        
  def event_index
		@event = Event.find_by_id(params[:id])
    @event_registrations = EventRegistration.where(event_id: params[:id])
    respond_to do |format|
      format.html { render :event_index }
      format.json { render :json => @event_registrations }
    end
  end

	def profile_index
		@profile = Profile.find_by_id(params[:id])
    @event = @profile.events.where('starts_at > ?', Time.zone.now.beginning_of_day).order(starts_at: :desc)
    respond_to do |format|
      format.html { render :profile_index }
      format.json { render :json => @event_registrations }
    end
	end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event_registration }
    end
  end

  def edit
  end

  def create
    @event_registration = EventRegistration.new(event_registration_params)
		@event_registration.profile_id = current_user.profile.id
		@event_registration.event_id = @event.id
		@event_registration.reserve_spot = @event.number_of_slots.present? && @event.event_registrations.count >= @event.number_of_slots 
    respond_to do |format|
      if @event_registration.save
        format.html { redirect_to event_event_registrations_path(@event), :notice => 'Du är nu anmäld till eventet!' }
        format.json { render :json => @event, :status => :created, :location => @event_registration }
      else
        format.html { render :action => "index" }
        format.json { render :json => @event_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event_registration.update(event_registration_params)
        format.html { redirect_to event_event_registrations_path(@event), :notice => 'Registreringen uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render :action => "index" }
        format.json { render :json => @event_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event_registration = EventRegistration.find(params[:id])
    @event_registration.destroy

    respond_to do |format|
      format.html { redirect_to @event }
      format.json { head :no_content }
    end
  end

  private
      def authenticate_admin
        flash[:error] = t('the_role.access_denied')
        redirect_to(:back) unless current_user && current_user.moderator?(:event)
        
        rescue ActionController::RedirectBackError
          redirect_to root_path
      end
      def authenticate
        flash[:error] = t('the_role.access_denied')
        redirect_to(:back) unless current_user && (current_user.moderator?(:event) || current_user.profile == EventRegistration.find_by_id(params[:id]).profile)
        
        rescue ActionController::RedirectBackError
          redirect_to root_path
      end
			def is_registrable
        flash[:error] = "Eventet går ej att registrera sig till"
        redirect_to(:back) unless Event.find_by_id(params[:event_id]).registrable?
        
        rescue ActionController::RedirectBackError
          redirect_to root_path
			end
      def set_event_registration
        @event_registration = EventRegistration.find_by_id(params[:id])
      end
      def event_registration_params
        params.require(:event_registration).permit(:profile_id, :event_id, :reserve_spot, :info_text)
      end
			def set_event
				@event = Event.find_by_id(params[:event_id])
			end
			def authenticate_user
        flash[:error] = t('the_role.access_denied')
      	redirect_to(:back) unless (current_user && current_user.profile.id.to_s == params[:id])
        
        rescue ActionController::RedirectBackError
          redirect_to root_path
			end
end
