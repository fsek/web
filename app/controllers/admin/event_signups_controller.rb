class Admin::EventSignupsController < Admin::BaseController
  before_action :load_permissions, :set_tab
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_signup, through: :event, singleton: true

  def create
    @event_signup = @event.build_event_signup(event_signup_params)
    if @event_signup.save
      redirect_to(admin_event_signup_path(@event), notice: alert_create(EventSignup))
    else
      set_grids(@event)
      render :show, status: 422
    end
  end

  def update
    if @event_signup.update(event_signup_params)
      redirect_to(admin_event_signup_path(@event), notice: alert_update(EventSignup))
    else
      set_grids(@event)
      render :show, status: 422
    end
  end

  def show
    @event_signup = @event.signup
    @event_signup ||= @event.build_event_signup
    set_grids(@event)

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def destroy
    @event_signup.destroy!
    redirect_to(edit_admin_event_path(@event), notice: alert_destroy(EventSignup))
  end

  private

  def event_signup_params
    params.require(:event_signup).permit(:for_members, :closes, :slots, :question_sv, :question_en,
                                        :novice, :mentor, :member, :custom, :custom_name, :opens)
  end

  def set_tab
    @tab = params.fetch(:tab, :settings).to_sym
    params[:tab] = @tab
  end

  def set_grids(event)
    @attending = EventUser.attending(event).for_grid
    @reserves = EventUser.reserves(event).for_grid
  end
end
