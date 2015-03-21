# encoding: UTF-8
class Nomination < ActiveRecord::Base
  belongs_to :election
  belongs_to :post

  validates_presence_of :name, :email, :post_id

  after_create :send_email

  def send_email
    ElectionMailer.nominate_email(self).deliver
  end
end
