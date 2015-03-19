class Documents::TagsController < ApplicationController
  before_action :authenticate
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to Tag, notice: 'Dokumentsamlingstypen skapades!'
    else
      render action: 'new'
    end
  end

  def update
    @tag.update_attributes(tag_params)
    if @tag.save
      redirect_to Tag, notice: 'Dokumentsamlingstypen uppdaterades!'
    else
      render action: 'edit'
    end
  end

  def destroy
    @tag.destroy!
    redirect_to Tag
  end

  private
    def authenticate
      unless current_user && current_user.moderator?(:tags)
        redirect_to root_url, alert: 'Du får inte göra så.'
      end
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

end
