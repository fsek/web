module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :ability, to: :connection
    protected :ability
  end
end
