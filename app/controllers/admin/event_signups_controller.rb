class Admin::EventSignupsController < Admin::BaseController
  before_action :load_permissions, :set_tab
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_signup, through: :event, singleton: true

  def create
    @event_signup = @event.build_event_signup(event_signup_params)
    if @event_signup.save
      redirect_to(admin_event_signup_path(@event), notice: alert_create(EventSignup))
    else
      render :show, status: 422
    end
  end

  def update
    if @event_signup.update(event_signup_params)
      redirect_to(admin_event_signup_path(@event), notice: alert_update(EventSignup))
    else
      render :show, status: 422
    end
  end

  def show
    @event_signup = @event.signup
    @event_signup ||= @event.build_event_signup(opens: Time.zone.now,
                                                closes: @event.starts_at,
                                                for_members: false)
    set_grids
  end

  def destroy
    @event_signup.destroy!
    redirect_to(edit_admin_event_path(@event), notice: alert_destroy(EventSignup))
  end

  def export
    respond_to do |format|
      format.csv do
        if params[:list] == 'reserves'
          set_reserves
          send_data(ExportCSV.event_users(@reserves, @event_signup),
                    filename: "reserver_till_#{@event.to_s.parameterize}.csv")
        else
          set_attending
          send_data(ExportCSV.event_users(@attending, @event_signup),
                    filename: "anmalda_till_#{@event.to_s.parameterize}.csv")
        end
      end
    end
  end

  private

  def event_signup_params
    params.require(:event_signup).permit(:for_members, :closes, :slots, :question_sv, :question_en,
                                         :notification_message_sv, :notification_message_en,
                                         :novice, :mentor, :member, :custom, :custom_name, :opens,
                                         group_types: [])
  end

  def set_tab
    @tab = params.fetch(:tab, :settings).to_sym
    params[:tab] = @tab
  end

  def set_grids
    set_attending
    set_reserves
  end

  def set_attending
    @attending = EventUser.attending(@event).for_grid
  end

  def set_reserves
    @reserves = EventUser.reserves(@event).includes([:user, group: :introduction])
  end
end
