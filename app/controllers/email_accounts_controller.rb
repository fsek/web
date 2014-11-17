# encoding:UTF-8
class EmailAccountsController < ApplicationController
  
  before_filter :authenticate
  before_action :set_account, except: [:index]

  def index
    @accounts_grid = initialize_grid(EmailAccount.all)
  end
  def new
    @account = EmailAccount.new()
  end
  def show
    @account = EmailAccount.find_by_id(params[:id])
  end
  def create
    @account = EmailAccount.new(account_params)
    @account.save
    respond_to do |format|
      if @account.save
        format.html { redirect_to email_account_path(@account), notice: 'Mejlkontot skapades, success.' }
        format.json { render action: 'show', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Mejlkontot uppdaterades, gött' }
        format.json { head :no_content }
      else
        format.html { redirect_to @account, error: 'Något blev fel.' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  private 
  def authenticate
    flash[:error] = t('the_role.access_denied')
      redirect_to(:back) unless (current_user) && (current_user.moderator?(:mejl))    
      rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  def set_account    
      @account = EmailAccount.find_by_id(params[:id])    
  end
  def account_params
    params.require(:email_account).permit(:title, :email, :active,:profile_id)
  end
end
