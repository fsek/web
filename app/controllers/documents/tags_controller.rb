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
    respond_to do |format|
      if @tag.save
        format.html { redirect_to Tag, notice: 'Dokumentsamlingstypen skapades!' }            
      else
        format.html { render action: 'new' }            
      end        
    end
  end

  def update  
    @tag.update_attributes(tag_params)        
    respond_to do |format|
      if @tag.save
        format.html { redirect_to Tag, notice: 'Dokumentsamlingstypen uppdaterades!' }
      else
        format.html { render action: 'edit' }
      end        
    end
  end

  def destroy
    @tag.destroy!
    redirect_to Tag
  end

  private
    def authenticate
      redirect_to root_url, alert: 'Du får inte göra så.' unless current_user && current_user.moderator?(:tags)
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

end
