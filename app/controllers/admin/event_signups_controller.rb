class Admin::EventSignupsController < Admin::BaseController
  before_action :load_permissions, :set_tab
  load_and_authorize_resource :event, parent: true
  load_and_authorize_resource :event_signup, through: :event, singleton: true

  def create
    @event_signup = @event.build_event_signup(event_signup_params)
    if @event_signup.save
      redirect_to(admin_event_signup_path(@event), notice: alert_create(EventSignup))
    else
      @attending_grid = set_grid(@event)
      render :show, status: 422
    end
  end

  def update
    if @event_signup.update(event_signup_params)
      redirect_to(admin_event_signup_path(@event), notice: alert_update(EventSignup))
    else
      @attending_grid = set_grid(@event)
      render :show, status: 422
    end
  end

  def show
    @event_signup = @event.signup
    @event_signup ||= @event.build_event_signup
    @attending_grid = set_grid(@event)
  end

  def destroy
    @event_signup.destroy!
    redirect_to(edit_admin_event_path(@event), notice: alert_destroy(EventSignup))
  end

  private

  def event_signup_params
    params.require(:event_signup).permit(:for_members, :last_reg, :slots, :question_sv, :question_en,
                                        :novice, :mentor, :member, :custom, :custom_name)
  end

  def set_tab
    @tab = params.fetch(:tab, :settings).to_sym
    params[:tab] = @tab
  end

  def set_grid(event)
      initialize_grid(EventUser.attending(event),
                      include: :user,
                      order: :created_at,
                      name: :attending)
  end
end
