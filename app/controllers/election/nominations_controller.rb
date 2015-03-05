class Election::NominationsController < ApplicationController
  before_action :login_required
  before_action :set_election
  def new
    @nomination = @election.nominations.new()
    if params[:post].present?
      @nomination.post == Post.find_by_id(params[:post])
    end
  end

  def create
    @nomination = @election.nominations.build(nomination_params)
    if @nomination.save
      @saved = true
      # Background job send_mail
      # ElectionMailer.nominate_email(@nomination).deliver
    end
  end
  private
  def set_election
    @election = Election.current
  end
  def nomination_params
    params.require(:nomination).permit(:name,:email,:motivation,:post_id)
  end
end
