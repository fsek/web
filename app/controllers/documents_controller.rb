# encoding:UTF-8
class DocumentsController < ApplicationController
  
  before_filter :authenticate, only: [:update,:edit,:new,:destroy,:create]
  before_action :set_document, only: [:show,:update,:edit,:destroy]
  before_action :set_edit  
  
  def index
    if(current_user)
      @logged_in = true
      @documents = Document.all
    else
      @documents = Document.publik      
    end
    @documents_grid = initialize_grid(@documents)
  end
  
  def new
    @dokument = Document.new
  end
  
  def show
    if(!@dokument.public) && (!current_user)
      redirect_to action: :index
      @documents = Document.publik
      @documents_grid = initialize_grid(@documents)
      return
    elsif((!@dokument.public) && (current_user) && (@dokument.pdf_file_name) || (@dokument.public))
      send_file(@dokument.pdf.path, filename:@dokument.pdf_file_name, type: "application/pdf",disposition: 'inline',x_sendfile: true)
      return
    end
  end
  def edit    
  end
  
  def create
    @user = current_user
    if(@user)
      if(@user.profile)
        @dokument = Document.new(document_params) 
        @dokument.update(profile_id: @user.profile.id)
        @dokument.pdf = params[:document][:pdf]       
        respond_to do |format|
          if @dokument.save
            format.html { redirect_to documents_path, :notice => 'Dokumentet skapades!' }            
          else
            format.html { render action: "new" }            
          end        
        end
      end
    end
  end
  
  def update  
    @dokument.update_attributes(document_params)        
    respond_to do |format|
      if @dokument.save
        format.html { redirect_to edit_document_path(@dokument), :notice => 'Dokumentet uppdaterades.' }
        format.json { render :json => @dokument, :status => :created, :location => @dokument }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @dokument.errors, :status => :unprocessable_entity }
      end        
    end
  end
  def destroy    
    @dokument.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
  private
    def authenticate
      flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless (current_user) && (current_user.moderator?(:dokument))    
      rescue ActionController::RedirectBackError
      redirect_to root_path
    end
    def set_document
      @dokument = Document.find_by_id(params[:id])
    end    
    def set_edit
      if(current_user) && (current_user.moderator?(:dokument))
        @edit = true
      else
        @edit = false
      end 
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:title, :public,:download,:category)
    end
end
