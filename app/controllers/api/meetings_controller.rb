class Api::MeetingsController < Api::BaseController
  def index
    meetings = Meeting.for_room(:sk).tablet_feed(5)
    render json: meetings
  end
end
