class EmailsController < ApplicationController
  
  before_filter :authenticate_user, only: [:index]
  before_filter :authenticate_admin, only: [:new,:edit,:create,:update,:destroy]
  before_action :set_account

  def index
    @message = Email.new()
    @old = @account.emails
  end
  def new
    @account = EmailAccount.new()
  end
  def create
    @account = EmailAccount.new(account_params)
    @account.save
    respond_to do |format|
      if @account.save
        format.html { redirect_to email(@account), notice: 'Utskott skapades, success.' }
        format.json { render action: 'show', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
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
    params.require(:email).permit(:receiver, :subject, :message)
  end
end
