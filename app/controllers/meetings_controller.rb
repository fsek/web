class MeetingsController < ApplicationController
  before_action :load_room, only: [:index, :new]
  before_action :set_room, only: :index
  load_permissions_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: @meetings.between(params[:start], params[:end])
      end
    end
  end

  def new
    @meeting.room = @room
  end

  def show
  end

  def edit
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user = current_user
    @meeting.status = :unconfirmed

    if @meeting.save
      MeetingMailer.book_email(@meeting).deliver_now
      redirect_to edit_meeting_path(@meeting), notice: alert_create(Meeting)
    else
      render :new, status: 422
    end
  end

  def update
    if @meeting.update(meeting_params)
      MeetingMailer.update_email(@meeting, current_user).deliver_now
      redirect_to edit_meeting_path(@meeting), notice: alert_update(Meeting)
    else
      render :edit, status: 422
    end
  end

  def destroy
    room = @meeting.room
    @meeting.destroy!

    redirect_to meetings_path(room: room), notice: alert_destroy(Meeting)
  end

  private

  def meeting_params
    params.require(:meeting).permit(:start_date, :end_date, :title, :purpose,
                                    :room, :council_id)
  end

  def load_room
    @room = params.fetch(:room, 'sk')
  end

  def set_room
    @meetings = Meeting.where(room: Meeting.rooms[@room])
  end
end
