class DocumentsController < ApplicationController
  before_filter :authenticate, except: [:steering, :protocols, :other, :show]
  before_action :set_document, only: [:show, :update, :edit, :destroy]

  def index
    @documents = Document.all.order('title ASC')
  end

  def steering
    @document_group = DocumentGroup.find_by_type('styrdokument').first

    @bylaws       = Document.public_records.find_by_group_and_tag('styrdokument', 'stadga').order('revision_date DESC')
    @regulations  = Document.public_records.find_by_group_and_tag('styrdokument', 'reglemente').order('revision_date DESC')
    @policys      = Document.public_records.find_by_group_and_tag('styrdokument', 'policy').order('title ASC')
    @rules        = Document.public_records.find_by_group_and_tag('styrdokument', 'regel').order('title ASC')
  end

  def protocols
    @general_meetings = DocumentGroup.find_by_type('sektionsmöte')
    @board_meetings = DocumentGroup.find_by_type('styrelsemöte')
  end

  def other
    @document_groups = DocumentGroup.find_without_type(['styrdokument', 'sektionsmöte', 'styrelsemöte'])
  end
  
  def new
    @document = Document.new
    @document.document_group = DocumentGroup.find_by_id(params[:document_group])
    @document.hidden = false
    @document.public = true
    @document.all_tags = params[:tag] if params[:tag].present?
  end
  
  def show
    if (!@document.hidden && @document.public) ||
       (!@document.hidden && current_user) ||
       (current_user && current_user.moderator?(:documents))

      send_file(@document.pdf.path, filename: @document.pdf_file_name, type: 'application/pdf', disposition: 'inline', x_sendfile: true)
    else
      redirect_to :back, alert: 'Du får inte göra så.'
    end
  end

  def edit    
  end
  
  def create
    @document = Document.new(document_params)
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document.document_group, notice: 'Dokumentet skapades!' }            
      else
        format.html { render action: 'new' }            
      end        
    end
  end
  
  def update  
    @document.update_attributes(document_params)        
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document.document_group, notice: 'Dokumentet uppdaterades!' }
      else
        format.html { render action: 'edit' }            
      end        
    end
  end

  def destroy
    dg = @document.document_group
    @document.destroy!
    redirect_to dg
  end
  
  private
    def authenticate
      redirect_to root_url, alert: 'Du får inte göra så.' unless current_user && current_user.moderator?(:documents)
    end

    def set_document
      @document = Document.find(params[:id])
    end    

    def document_params
      params.require(:document).permit(:title, :production_date, :revision_date, :public, :hidden, :document_group_id, :pdf, :all_tags)
    end
end
