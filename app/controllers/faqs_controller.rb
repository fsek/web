# encoding:UTF-8
class FaqsController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :set_editor, only: [:new, :show, :edit, :index]

  def index
    @faq = Faq.where.not(answer: '').where(category: 'main')
    if @editor
      @faq_unanswered = Faq.where(answer: '', category: 'main')
    end
  end

  def show
  end

  def new
    if params[:category].present?
      @faq.category = params[:category]
    end
  end

  def edit
  end

  def destroy
    @faq.destroy
    redirect_to :faqs
  end

  def update
    if @faq.update(faq_params)
      redirect_to @faq, notice: 'FAQ uppdaterades!'
    else
      render action: 'edit'
    end
  end

  def create
    if @faq.answer.nil?
      @faq.answer = ''
    end
    if @faq.save
      redirect_to @faq, notice: 'Frågan skapades!'
    else
      render action: 'new'
    end
  end

  private

  def set_editor
    @editor = can? :manage, Faq
  end

  def faq_params
    params.require(:faq).permit(:question, :answer, :category)
  end
end
