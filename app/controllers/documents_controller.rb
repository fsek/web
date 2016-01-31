# encoding:UTF-8
class DocumentsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    documents = set_documents(params[:category])
    grid = initialize_grid(documents, order: 'documents.updated_at',
                                      order_direction: 'desc')

    @documents = DocumentView.new(grid: grid,
                                  categories: Document.categories,
                                  current_category: params[:category])
  end

  def show
    document = Document.find(params[:id])
    send_file(document.pdf.path,
              filename: document.pdf_file_name,
              type: 'application/pdf',
              disposition: 'inline',
              x_sendfile: true)
  end

  private

  def set_documents(category)
    if current_user.try(:member?)
      filter_documents(Document.all, category)
    else
      filter_documents(Document.publik, category)
    end
  end

  def filter_documents(documents, category)
    if category.present?
      documents.where(category: category)
    else
      documents
    end
  end
end
