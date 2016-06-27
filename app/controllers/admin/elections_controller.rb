# encoding: UTF-8
class Admin::ElectionsController < Admin::BaseController
  load_permissions_and_authorize_resource find_by: :url

  def new
    @election = Election.new
  end

  def show
    @election = Election.find_by_url!(params[:id])
    @post_grid = initialize_grid(@election.posts, include: :council)
  end

  def edit
    @election = Election.find_by_url!(params[:id])
  end

  def index
    @grid = initialize_grid(Election, order: :open)
  end

  def create
    @election = Election.new(election_params)
    if @election.save
      redirect_to admin_election_path(@election), notice: alert_create(Election)
    else
      render :new, status: 422
    end
  end

  def update
    @election = Election.find_by_url!(params[:id])
    if @election.update(election_params)
      redirect_to admin_election_path(@election), notice: alert_update(Election)
    else
      render :show, status: 422
    end
  end

  def destroy
    election = Election.find_by_url!(params[:id])
    election.destroy!
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

  def election_params
    params.require(:election).permit(:title, :description, :open, :close_general, :close_all,
                                     :url, :visible, :mail_link, :board_mail_link,
                                     :nominate_mail, :candidate_mail, :semester,
                                     :candidate_mail_star, extra_post_ids: [])
  end
end
