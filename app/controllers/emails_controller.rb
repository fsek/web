# encoding:UTF-8
class EmailsController < ApplicationController
  
  before_filter :authenticate_user, only: [:index,:new,:create,:show]  
  before_action :set_account

  def index    
    @old = @account.emails
  end
  def show
    @email = Email.find_by_id(params[:id])
    if not(@email.email_account.profile == current_user.profile)
      flash[:error] = t('the_role.access_denied')
      redirect_to(:back)
    end  
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  def new
    @email = @account.emails.new()
  end  
  def create
    @email = @account.emails.new(email_params)    
    respond_to do |format|
      if (@email.save) && (EmailMailer.send_email(@account,@email).deliver)
        format.html { redirect_to emails_path(), notice: 'Mejlet skapades, success.' }
        format.json { render action: 'show', status: :created, location: @email }
      else
        format.html { render action: 'new' }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end
  private
  def authenticate_user
    flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless (current_user) && (current_user.profile.email_account) && (current_user.profile.email_account.active)    
      rescue ActionController::RedirectBackError
      redirect_to root_path
  end  
  def set_account
    if(current_user) && (current_user.profile.email_account)
      @account = current_user.profile.email_account
    end  
  end
  def email_params
    params.require(:email).permit(:receiver, :subject, :message,:copy)
  end
end
