require 'rails_helper'

RSpec.describe "ExLinks", type: :request do
  describe "GET /ex_links" do
    it "works! (now write some real specs)" do
      get ex_links_path
      expect(response).to have_http_status(200)
    end
  end
end
