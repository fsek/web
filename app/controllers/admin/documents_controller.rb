class Admin::DocumentsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    documents = filter_documents(Document.all, params[:category])
    grid = initialize_grid(documents, order: 'documents.updated_at',
                                      order_direction: 'desc',
                                      include: :user)

    @documents = DocumentView.new(grid: grid,
                                  categories: Document.categories,
                                  current_category: params[:category])
  end

  def edit
    @document = Document.find(params[:id])
    @categories = Document.categories
  end

  def new
    @document = Document.new
    @categories = Document.categories
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    @categories = Document.categories

    if @document.save
      redirect_to edit_admin_document_path(@document), notice: alert_create(Document)
    else
      render :new, status: 422
    end
  end

  def update
    @document = Document.find(params[:id])
    @document.user = current_user
    @categories = Document.categories

    if @document.update(document_params)
      redirect_to edit_admin_document_path(@document), notice: alert_update(Document)
    else
      render :edit, status: 422
    end
  end

  def destroy
    document = Document.find(params[:id])

    document.destroy!
    redirect_to admin_documents_path, notice: alert_destroy(Document)
  end

  private

  def document_params
    params.require(:document).permit(:title, :pdf, :public, :category)
  end

  def filter_documents(documents, category)
    if category.present?
      documents.where(category: category)
    else
      documents
    end
  end
end
