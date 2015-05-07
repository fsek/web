# encoding:UTF-8
class DocumentsController < ApplicationController
  before_action :set_documents, only: :index
  load_permissions_and_authorize_resource

  def index
    @documents_grid = initialize_grid(@documents)
  end

  def new
  end

  def show
    send_file(@document.pdf.path, filename: @document.pdf_file_name,
              type: 'application/pdf',
              disposition: 'inline', x_sendfile: true)
  end

  def edit
  end

  def create
    if @document.save
      redirect_to documents_path, notice: alert_create(Document)
    else
      render action: :new
    end
  end

  def update
    if @document.update(document_params)
      redirect_to edit_document_path(@document), notice: alert_update(Document)
    else
      render action: :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_url, notice: alert_destroy(Document)
  end

  private

  def set_documents
    @documents = (current_user) ? Document.all : Document.public
  end

  def document_params
    params.require(:document).permit(:title, :public, :download, :category, :pdf)
  end
end
