# encoding: UTF-8
class Admin::ElectionsController < ApplicationController
  load_permissions_and_authorize_resource find_by: :url
  before_action :authorize
  before_action :set_posts, only: [:new, :show, :edit]

  def new
  end

  def show
  end

  def edit
  end

  def index
    @elections = Election.order(start: :desc)
  end

  def create
    if @election.save
      redirect_to admin_election_path(@election), notice: alert_create(Election)
    else
      render action: :new
    end
  end

  def update
    if @election.update(election_params)
      redirect_to admin_election_path(@election), notice: alert_update(Election)
    else
      render action: :show
    end
  end

  def destroy
    @election.destroy!
    redirect_to admin_elections_path, notice: alert_destroy(Election)
  end

  def nominations
    @nominations_grid = initialize_grid(@election.nominations,
                                        name: 'nominations',
                                        include: :post)
  end

  def candidates
    @candidates_grid = initialize_grid(@election.candidates,
                                       name: 'candidates',
                                       include: [:post, :user])
  end

  private

  def authorize
    authorize! :manage, Election
  end

  def election_params
    params.fetch(:election).permit(:title, :description, :start, :end, :closing, :url,
                                   :visible, :mail_link, :mail_styrelse_link, :text_before,
                                   :text_during, :text_after, :nominate_mail, :candidate_mail,
                                   :extra_text, :candidate_mail_star, post_ids: [])
  end

  def set_posts
    @posts = Post.order(title: :asc)
  end
end
