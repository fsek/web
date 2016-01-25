# encoding:UTF-8
class DocumentsController < ApplicationController
  before_action :set_documents, only: :index
  load_permissions_and_authorize_resource

  def index
    @documents = @documents.where(category: params[:category])
    @documents_grid = initialize_grid(@documents)
    @categories = Document.pluck(:category).uniq
  end

  def new
  end

  def show
    send_file(@document.pdf.path, filename: @document.pdf_file_name,
                                  type: 'application/pdf',
                                  disposition: 'inline',
                                  x_sendfile: true)
  end

  def edit
  end

  def create
    if @document.save
      redirect_to documents_path, notice: alert_create(Document)
    else
      render :new, status: 422
    end
  end

  def update
    if @document.update(document_params)
      redirect_to edit_document_path(@document), notice: alert_update(Document)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @document.destroy!
    redirect_to documents_url, notice: alert_destroy(Document)
  end

  private

  def set_documents
    if current_user.try(:member?)
      @documents = Document.all
    else
      Document.publik
    end
  end

  def document_params
    params.require(:document).permit(:title, :public, :download, :category, :pdf)
  end
end
