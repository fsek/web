class DocumentGroupsController < ApplicationController
  before_action :set_document_group, only: [:edit, :update, :destroy]

  def new
    @document_group = DocumentGroup.new
  end

  def edit
  end

  def create
    @document_group = DocumentGroup.new(document_group_params)

    respond_to do |format|
      if @document_group.save
        flash[:notice] = 'Dokumentsamling skapad.'
        format.html { redirect_to edit_document_group_url(@document_group) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
  end

  def destroy
    @document_group.destroy!
    redirect_to steering_documents_url
  end

  private
    def set_document_group
      @document_group = DocumentGroup.find(params[:id])
    end

    def document_group_params
      params.require(:document_group).permit(:name, :document_group_type_id)
    end
end
