require 'rails_helper'

RSpec.describe GithookController, type: :controller do
  describe 'githook', type: 'request' do
    it 'requires authentication' do
      get '/githook/master'
      expect(response).to have_http_status(:found)
    end
    it 'requires sha hash' do
      headers = { HTTP_X_HUB_SIGNATURE: '' }
      post '/githook', '', headers
      expect(response).to have_http_status(500)
    end
    it 'accepts github token' do
      json_payload = '{"ref": "refs/heads/foo"}'
      headers = {
        format: 'json',
        HTTP_X_HUB_SIGNATURE: 'sha1=87db15ae6db2fa97763ebad0926c8389fdbbc325'
      }
      post '/githook', json_payload, headers
      expect(response).to have_http_status(200)
    end
  end
end
