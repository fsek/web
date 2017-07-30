require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth (Sign Up process)' do
    it 'valid parameters' do
      lambda do
        post api_user_registration_path(firstname: 'Jakob',
                                        lastname: 'Navrozidis',
                                        email: 'jakob@fsektionen.se',
                                        password: 'godtyckligt',
                                        password_confirmation: 'godtyckligt')
      end.should change(User, :count).by(1)

      response.should have_http_status(200)
    end

    it 'invalid parameters' do
      lambda do
        post api_user_registration_path(firstname: 'Jakob',
                                        email: 'jakob@fsektionen.se',
                                        password: 'godtyckligt',
                                        password_confirmation: 'godtyckligt')
      end.should change(User, :count).by(0)

      response.should have_http_status(422)
    end

    it 'no password confirmation' do
      lambda do
        post api_user_registration_path(firstname: 'Jakob',
                                        lastname: 'Navrozidis',
                                        email: 'jakob@fsektionen.se',
                                        password: 'godtyckligt')
      end.should change(User, :count).by(0)

      response.should have_http_status(422)
    end
  end

  describe 'POST /auth/sign_in (Sign In process)' do
    it 'valid parameters' do
      # Create a new user
      post api_user_registration_path(firstname: 'Jakob',
                                      lastname: 'Navrozidis',
                                      email: 'jakob@fsektionen.se',
                                      password: 'godtyckligt',
                                      password_confirmation: 'godtyckligt')
      # Mark email as confirmed
      User.last.update!(confirmed_at: Time.zone.now)

      # Sign In
      post api_user_session_path(email: 'jakob@fsektionen.se', password: 'godtyckligt')
      response.should be_success
      response.should have_http_status(200)
    end

    it 'invalid parameters' do
      # Create a new user
      post api_user_registration_path(firstname: 'Jakob',
                                      lastname: 'Navrozidis',
                                      email: 'jakob@fsektionen.se',
                                      password: 'godtyckligt',
                                      password_confirmation: 'godtyckligt')
      # Mark email as confirmed
      User.last.update!(confirmed_at: Time.zone.now)

      # Sign In
      post api_user_session_path(email: 'jakob@fsektionen.se', password: 'ogodtyckligt')
      response.should_not be_success
      response.should have_http_status(401)
    end
  end
end
