class Documents::DocumentGroupsController < ApplicationController
  before_action :authenticate
  before_action :set_document_group, only: [:show, :update, :destroy]

  def index
    @document_groups = DocumentGroup.all.order('name ASC')
  end

  def show
  end

  def new
    type = DocumentGroupType.find_by_name(params[:type])
    @document_group = DocumentGroup.new document_group_type: type

    if params[:type].present? && type.blank?
      flash.now[:alert] = "Du ville skapa en dokumentsamlning av typen '#{params[:type]}' men den"\
                          "typen av dokumentsamling finns inte."
    end
  end

  def create
    @document_group = DocumentGroup.new(document_group_params)
    if @document_group.save
      redirect_to @document_group, notice: 'Dokumensamling skapad!'
    else
      render action: 'new'
    end
  end

  def update
    @document_group.update_attributes(document_group_params)
    if @document_group.save
      redirect_to @document_group, notice: 'Dokumentet uppdaterades!'
    else
      render action: 'show'
    end
  end

  def destroy
    @document_group.destroy!
    redirect_to steering_documents_url
  end

  private

    def authenticate
      unless current_user && current_user.moderator?(:document_groups)
        redirect_to root_url, alert: 'Du får inte göra så.'
      end
    end

    def set_document_group
      @document_group = DocumentGroup.find(params[:id])
    end

    def document_group_params
      params.require(:document_group).permit(:name, :production_date, :document_group_type_id)
    end

end
