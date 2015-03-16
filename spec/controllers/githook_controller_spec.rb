require 'rails_helper'

RSpec.describe GithookController, type: :controller do
  describe "githook", :type => :request do
    it "requires authentication" do
      get "/githook/master"
      expect(response).to have_http_status(:found)
    end
    it 'requires sha hash' do
      post '/githook', '', { HTTP_X_HUB_SIGNATURE: '' }
      expect(response).to have_http_status(500)
    end
    it 'accepts github token' do
      json_payload = '{"ref": "refs/heads/foo"}'
      post '/githook', json_payload, { format: 'json', HTTP_X_HUB_SIGNATURE: 'sha1=87db15ae6db2fa97763ebad0926c8389fdbbc325' }
      expect(response).to have_http_status(200)
    end
  end
end
