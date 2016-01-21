# encoding: UTF-8
class Contact < ActiveRecord::Base
  belongs_to :council
  validates :name, :email, :text, presence: true
  validates :email, uniqueness: true

  attr_accessor :sender_message, :sender_name, :sender_email

  def send_email
    ContactMailer.contact_email(self).deliver_now
  end

  def to_s
    name
  end
end
