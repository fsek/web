# encoding: UTF-8
class Contact < ActiveRecord::Base
  belongs_to :council
  # TODO Add belongs_to :post
  # Add an email model, to be able to validate messages and perhaps store them
  # for signed in users.
  validates :name, :email, :text, presence: true
  validates :email, uniqueness: true

  attr_accessor :copy, :message, :send_name, :send_email
  def mail(params)
    ContactMailer.contact_email(params[:send_name], params[:send_email],
                                params[:message], self, params[:copy]).deliver_now
  end

  def to_s
    name
  end
end
