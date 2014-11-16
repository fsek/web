class CouncilsController < ApplicationController
  
  before_filter :authenticate, only: [:new,:edit,:create,:update,:destroy]
  before_action :set_council, only: [:show, :edit, :update, :destroy]
  

  # GET /councils
  # GET /councils.json
  def index
    @councils = Council.all
  end

  # GET /councils/1
  # GET /councils/1.json
  def show
    if (@page)
      @mainelements = @page.page_elements.where(visible: true,sidebar: false)
      @sidebarelements = @page.page_elements.where(visible:true,sidebar: true)
    end
    if(@mainelemnents) && (@mainelements.count > 1)
      @mainelements = @mainelements.sort_by{ |x| x[:displayIndex]}
    end
    @poster = @council.posts
  end

  # GET /councils/new
  def new
    @council = Council.new
  end

  # GET /councils/1/edit
  def edit
    @contact = Contact.all.where(council_id: @council.id).first
    if not @contact
      @contact = Contact.new()
      @contact.council_id = @council.id
      @contact.save
    end      
  end

  # POST /councils
  # POST /councils.json
  def create
    @council = Council.new(council_params)
    @council.build_page(council_id: @council.id)
    respond_to do |format|
      if @council.save
        format.html { redirect_to edit_council_path(@council), notice: 'Utskott skapades, success.' }
        format.json { render action: 'edit', status: :created, location: @council }
      else
        format.html { render action: 'new' }
        format.json { render json: @council.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /councils/1
  # PATCH/PUT /councils/1.json
  def update
    respond_to do |format|
      if @council.update(council_params)
        format.html { redirect_to edit_council_path(@council), notice: 'Utskott uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @council.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /councils/1
  # DELETE /councils/1.json
  def destroy
    @council.destroy
    respond_to do |format|
      format.html { redirect_to councils_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_council
      @council = Council.find_by_url(params[:id])
      @page = @council.page
    end
    def authenticate
      flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless (current_user) && (current_user.moderator?(:utskott))    
      rescue ActionController::RedirectBackError
      redirect_to root_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def council_params
      params.require(:council).permit(:title,:url,:description,:president,:vicepresident,:public)
    end
end
