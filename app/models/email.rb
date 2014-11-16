class Email < ActiveRecord::Base
  has_one :email_account
end
