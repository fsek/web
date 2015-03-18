class Documents::DocumentGroupTypesController < ApplicationController
  before_action :authenticate
  before_action :set_document_group_type, only: [:show, :edit, :update, :destroy]

  def index
    @document_group_types = DocumentGroupType.all
  end

  def show
  end

  def new
    @document_group_type = DocumentGroupType.new
  end

  def edit
  end

  def create
    @document_group_type = DocumentGroupType.new(document_group_type_params)
    if @document_group_type.save
      redirect_to DocumentGroupType, notice: 'Dokumentsamlingstypen skapades!'
    else
      render action: 'new'
    end
  end

  def update
    @document_group_type.update_attributes(document_group_type_params)
    if @document_group_type.save
      redirect_to DocumentGroupType, notice: 'Dokumentsamlingstypen uppdaterades!'
    else
      render action: 'edit'
    end
  end

  def destroy
    @document_group_type.destroy!
    redirect_to DocumentGroupType
  end

  private

    def authenticate
      unless current_user && current_user.moderator?(:document_group_types)
        redirect_to root_url, alert: 'Du får inte göra så.'
      end
    end

    def set_document_group_type
      @document_group_type = DocumentGroupType.find(params[:id])
    end

    def document_group_type_params
      params.require(:document_group_type).permit(:name)
    end

end
