# encoding:UTF-8
class DocumentsController < ApplicationController
  before_filter :authenticate, only: [:update, :edit, :new, :destroy, :create]
  before_action :set_document, only: [:show, :update, :edit, :destroy]
  before_action :set_edit

  def steering
    @bylaws = Document.joins(document_group: :document_group_type).where("document_groups_types.name" => "stadga")
    @regulations = Document.joins(document_group: :document_group_type).where("document_group_types.name" => "reglemente")
    @policys = Document.joins(document_group: :document_group_type).where("document_group_types.name" => "policy")
    @rules = Document.joins(document_group: :document_group_type).where("document_group_types.name" => "regler")
  end

  def protocols
    
  end

  def other

  end
  
  def new
    @document = Document.new
  end
  
  def show
    if(!@document.public) && (!current_user)
      redirect_to action: :index
      @documents = Document.public_records
      @documents_grid = initialize_grid(@documents)
      return
    elsif((!@document.public) && (current_user) && (@document.pdf_file_name) || (@document.public))
      send_file(@document.pdf.path, filename:@document.pdf_file_name, type: "application/pdf",disposition: 'inline',x_sendfile: true)
      return
    end
  end
  def edit    
  end
  
  def create
    @user = current_user
    if(@user)
      if(@user.profile)
        @document = Document.new(document_params) 
        @document.update(profile_id: @user.profile.id)
        @document.pdf = params[:document][:pdf]       
        respond_to do |format|
          if @document.save
            format.html { redirect_to documents_path, :notice => 'Dokumentet skapades!' }            
          else
            format.html { render action: "new" }            
          end        
        end
      end
    end
  end
  
  def update  
    @document.update_attributes(document_params)        
    respond_to do |format|
      if @document.save
        format.html { redirect_to edit_document_path(@document), :notice => 'Dokumentet uppdaterades.' }
        format.json { render :json => @document, :status => :created, :location => @document }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @document.errors, :status => :unprocessable_entity }
      end        
    end
  end
  def destroy    
    @document.destroy
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
      @document = Document.find_by_id(params[:id])
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
