# encoding:UTF-8
class ContactsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def mail
    @contact.assign_attributes(mail_params)
    if @contact.send_email
      redirect_to contact_path(@contact), notice: t('contact.message_sent')
    else
      redirect_to contact_path(@contact), alert: t('contact.something_wrong')
    end
  end

  def create
    if @contact.save
      redirect_to @contact, notice: alert_create(Contact)
    else
      render :new, status: 422
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to edit_contact_path(@contact), notice: alert_update(Contact)
    else
      render :edit, status: 422
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, notice: alert_destroy(Contact)
  end

  private

  def mail_params
    params.require(:contact).permit(:sender_name, :sender_email, :sender_message)
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :public, :text, :council_id)
  end
end
