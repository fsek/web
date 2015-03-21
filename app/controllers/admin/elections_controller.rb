# encoding: UTF-8
class Admin::ElectionsController < ApplicationController
  before_action :login_required
  before_action :authenticate
  before_action :set_election, only: [:show, :edit, :update, :destroy, :candidates, :nominations]

  def new
    @election = Election.new
    @posts = Post.order(title: :asc)
  end

  def show
    @posts = Post.order(title: :asc)
  end

  def edit
    @posts = Post.order(title: :asc)
  end

  def index
    @elections = Election.order(start: :desc)
  end

  def create
    @election = Election.new(election_params)
    respond_to do |format|
      if @election.save
        format.html { redirect_to @election, notice: 'Eventet skapades!' }
        format.json { render json: @election, status: :created, location: @election }
      else
        format.html { render action: 'new' }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @election.update(election_params)
        format.html { redirect_to admin_election_path(@election), notice: 'Valet uppdaterades, gött' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @election.destroy
    respond_to do |format|
      format.html { redirect_to elections_path, notice: 'Valet raderades, hoppas att det var meningen!.' }
      format.json { head :no_content }
    end
  end

  def nominations
    @nominations_grid = initialize_grid(@election.nominations,
                                        name: 'g2',
                                        enable_export_to_csv: true,
                                        csv_file_name: 'nomineringar')
  end

  def candidates
    @candidates_grid = initialize_grid(@election.candidates, name: 'candidates', enable_export_to_csv: true, csv_file_name: 'candidates')
    export_grid_if_requested('g2' => 'nominations_grid')
  end

  private

  def authenticate
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back) unless (current_user) && (current_user.moderator?(:val))
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def election_params
    params.fetch(:election).permit(:title, :description, :start, :end, :url, :visible, :mail_link, :mail_styrelse_link, :text_before, :text_during, :text_after, :nominate_mail, :candidate_mail, :extra_text, :candidate_mail_star, post_ids: [])
  end

  def set_election
    @election = Election.find_by_url(params[:id])
    if !@election.instance_of?(Election)
      redirect_to action: :index
    end
  end
end
