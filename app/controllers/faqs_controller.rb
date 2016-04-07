# encoding:UTF-8
class FaqsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @faqs = @faqs.answered
  end

  def new
    @faq = Faq.new
  end

  def create
    if @faq.save
      redirect_to faqs_path, notice: alert_create(Faq)
    else
      render :new, status: 422
    end
  end

  private

  def faq_params
    params.require(:faq).permit(:question)
  end
end
