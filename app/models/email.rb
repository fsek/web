class Email < ActiveRecord::Base

  belongs_to :email_account  
  validates :email_account_id,:receiver,:subject, :message,:presence => {}
end
