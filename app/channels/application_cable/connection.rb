module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email
    end

    def ability
      @ability ||= Ability.new(current_user)
    end

    protected

    def find_verified_user
      cookie_user = env['warden'].user
      token = request.params[:token]

      if cookie_user.present?
        cookie_user
      elsif token.present?
        User.find(MessageToken.find(token))
      else
        reject_unauthorized_connection
      end
    end
  end
end
