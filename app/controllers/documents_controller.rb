class DocumentsController < ApplicationController
  
  before_action :authenticate_editor!
  before_action :set_document, only: [:show,:update,:edit]
  before_action :set_owner
  
  def index
    @documents = Document.all
  end
  
  def new
    @dokument = Document.new
  end
  
  def show    
  end
  
  def edit    
  end
  
  def create
    @user = current_user
    if(@user)
      if(@user.profile)
        @dokument = Document.new(document_params,profile_id: @user.profile.id)        
        respond_to do |format|
          if @dokument.save
            format.html { redirect_to @dokument, :notice => 'Dokumentet skapades!.' }
            format.json { render :json => @dokument, :status => :created, :location => @dokument }
          else
            format.html { render :action => "new" }
            format.json { render :json => @dokument.errors, :status => :unprocessable_entity }
          end        
        end
      end
    end
  end
  
  def update  
    @dokument = Document.new(document_params)        
    respond_to do |format|
      if @dokument.save
        format.html { redirect_to @dokument, :notice => 'Dokumentet skapades!.' }
        format.json { render :json => @dokument, :status => :created, :location => @dokument }
      else
        format.html { render :action => "new" }
        format.json { render :json => @dokument.errors, :status => :unprocessable_entity }
      end        
    end
  end
  private
    def set_document
      @dokument = Document.find_by_id(params[:id])
    end
    def set_owner
      if @dokument
        @owner = Profile.find_by_id(@dokument.profile_id)
      end
    end
    def authenticate_editor!
      @edit = false unless current_user
      @edit = false unless current_user.moderator?(:dokument)
      @edit = true 
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:pdf, :public,:download,:category,:pdf)
    end
end
