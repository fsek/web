require 'rails_helper'

RSpec.describe GithookController, type: :controller do
  describe "githook", :type => :request do
    it "returns bad request on invalid request" do
      params = {}
      post "githook#index", params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
