require 'rails_helper'

RSpec.describe GithookController, type: :controller do
  describe "githook", :type => :request do
    it "requires authentication" do
      get "githook/master"
      expect(response).to have_http_status(:found)
    end
  end
end
