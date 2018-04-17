class ContactMessage
  include ActiveModel::Model

  attr_accessor :message, :name, :email
  attr_reader :errors

  def initialize(attributes = {}, _options = {})
    @errors = ActiveModel::Errors.new(self)
    @message = attributes[:message]
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def validate!
    ContactMessageValidator.validate(self)
  end
end
