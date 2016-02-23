# encoding:UTF-8
class Admin::ContactsController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
    @contact_grid = initialize_grid(Contact, include: :post)
  end

  def new
    @contact = Contact.new
    @posts = Post.title
  end

  def edit
    @contact = Contact.find(params[:id])
    @posts = Post.title
  end

  def create
    @contact = Contact.new(contact_params)
    @posts = Post.title
    if @contact.save
      redirect_to admin_contact_path(@contact), notice: alert_create(Contact)
    else
      render :new, status: 422
    end
  end

  def update
    @contact = Contact.find(params[:id])
    @posts = Post.title
    if @contact.update(contact_params)
      redirect_to edit_admin_contact_path(@contact), notice: alert_update(Contact)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy!
    redirect_to admin_contacts_path, notice: alert_destroy(Contact)
  end

  private

  def authorize
    authorize!(:manage, Contact)
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :public, :text, :post_id, :slug)
  end
end