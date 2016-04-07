# encoding:UTF-8
class Admin::FaqsController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
    @faq_grid = initialize_grid(@faqs, order: :created_at)
  end

  def new
  end

  def edit
  end

  def destroy
    @faq.destroy!

    redirect_to admin_faqs_path, notice: alert_destroy(Faq)
  end

  def update
    if @faq.update(faq_params)
      redirect_to edit_admin_faq_path(@faq), notice: alert_update(Faq)
    else
      render :edit, status: 422
    end
  end

  def create
    if @faq.save
      redirect_to edit_admin_faq_path(@faq), notice: alert_create(Faq)
    else
      render :new, status: 422
    end
  end

  private

  def faq_params
    params.require(:faq).permit(:question, :answer, :category)
  end
end
