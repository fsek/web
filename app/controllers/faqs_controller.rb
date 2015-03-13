# encoding:UTF-8
class FaqsController < ApplicationController

  before_action :authenticate_editor, only: [:edit, :update, :destroy]
  before_action :set_editor, only: [:new, :show, :edit, :index]
  before_action :set_faq, only: [:show, :edit, :update, :destroy]


  def index
    @faq = Faq.where.not(answer: '').where(category: 'main')
    if @editor
      @faq_unanswered = Faq.where(answer: '', category: 'main')
    end
  end

  def show
  end

  def new
    @faq = Faq.new
    if (params[:category])
      @faq.category = params[:category]
    end
  end

  def edit
  end

  def destroy
    @faq.destroy()
    respond_to do |format|
      format.html { redirect_to :faqs }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @faq.update(faq_params)
        format.html { redirect_to @faq, notice: 'FAQ uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.answer == nil
      @faq.answer = ''
    end
    respond_to do |format|
      if @faq.save
        format.html { redirect_to @faq, notice: 'Frågan skapades!' }
        format.json { render action: 'show', status: :created, location: @faq }
      else
        format.html { render action: 'new' }
        format.json { render json: @faq.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_faq
    @faq = Faq.find(params[:id])
  end

  def authenticate_editor
    if !(current_user) || !(current_user.moderator?(:faq))
      flash[:error] = "Funkar inte"
      redirect_to :faq
    end
  end

  def set_editor
    if (current_user) && (current_user.moderator?(:faq))
      @editor = true
    else
      @editor = false
    end
  end

  def faq_params
    params.require(:faq).permit(:question, :answer, :category)
  end

end
