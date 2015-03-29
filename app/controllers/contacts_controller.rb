# encoding:UTF-8
class ContactsController < ApplicationController
  before_filter :authenticate_edit, only: [:new, :edit, :update, :destroy]
  before_action :set_contact, only: [:show, :edit, :update, :destroy, :mail]

  def index
    @contacts = Contact.all
  end

  def show
    @sent = false
  end

  def new
    @contact = Contact.new
  end

  def edit
  end

  def mail
    if (params[:name]) && (params[:email]) && (params[:msg])
      @name = params[:name]
      @email = params[:email]
      @msg = params[:msg]
      ContactMailer.contact_email(@name, @email, @msg, @contact).deliver_now
      respond_to do |format|
        format.html { redirect_to @contact, notice: 'Meddelandet skickades.' }
        format.json { render action: 'show', status: :created, location: @contact }
        @sent = true
      end
    end
  end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Kontakten skapades, success.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { render action: 'edit', notice: 'Kontakten uppdaterades!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find_by_id(params[:id])
    if (@contact == nil)
      redirect_to(contacts_path, notice: 'Ingen kontakt hittades.')
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :public, :text, :council_id)
  end
end
