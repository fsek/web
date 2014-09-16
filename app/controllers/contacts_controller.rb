class ContactsController < ApplicationController
  before_filter :authenticate_edit, only: [:new,:edit,:update,:destroy]  
  before_action :set_contact, only: [:show, :edit,:update,:destroy,:mail]

  # GET /councils
  # GET /councils.json
  def index
    @contacts = Contact.all
  end

  # GET /councils/1
  # GET /councils/1.json
  def show
    @sent = false
  end

  # GET /councils/new
  def new
    @contact = Contact.new
  end

  # GET /councils/1/edit
  def edit
  end
  def mail    
    if(params[:name]) && (params[:email]) && (params[:msg])
      @name = params[:name]
      @email = params[:email]
      @msg = params[:msg]
      ContactMailer.contact_email(@name,@email,@msg,@contact).deliver
      respond_to do |format|
        format.html { redirect_to @contact, notice: 'Meddelandet skickades.' }
        format.json { render action: 'show', status: :created, location: @contact }
        @sent = true
      end
    end  
  end

  # POST /councils
  # POST /councils.json
  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Kontakten skapades, success.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /councils/1
  # PATCH/PUT /councils/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { render action: 'edit' , notice: 'Kontakten uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /councils/1
  # DELETE /councils/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end
    def authenticate_edit
      flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless current_user.moderator?(:kontakt)
    
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name,:email,:public,:text,:council_id)
    end    
end
