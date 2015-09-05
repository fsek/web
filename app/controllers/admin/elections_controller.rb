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
      redirect_to [:admin, @election], notice: 'Valet skapades'
    else
      render action: :new
    end
  end

  def update
    if @election.update(election_params)
      redirect_to [:admin, @election], notice: 'Valet uppdaterades, gött'
    else
      render action: :edit
    end
  end

  def destroy
    @election.destroy
    redirect_to admin_elections_path, notice: 'Valet raderades, hoppas att det var meningen!.'
  end

  def nominations
    @nominations_grid = initialize_grid(@election.nominations,
                                        name: 'g2',
                                        enable_export_to_csv: true,
                                        csv_file_name: 'nomineringar')
  end

  def candidates
    @candidates_grid = initialize_grid(@election.candidates,
                                       name: 'candidates',
                                       enable_export_to_csv: true,
                                       csv_file_name: 'candidates')
    export_grid_if_requested('g2' => 'nominations_grid')
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
