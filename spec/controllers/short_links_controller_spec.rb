require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  allow_user_to(:manage, ShortLink)

  describe '#go' do
    it 'redirects to the link when present' do
      link = 'hej'
      target = 'http://hej.se'
      sl = create(:short_link, link: link, target: target)

      get :go, params: { link: link }

      response.status.should eq(301)
      response.location.should eq(sl.target)
    end

    it 'throws 404 when link is not found' do
      lambda do
        get :go, params: { link: 'nonexistent' }
      end.should raise_error ActionController::RoutingError
    end
  end

  describe '#check' do
    it 'returns 204 when link exists' do
      link = 'testlink'
      create :short_link, link: link

      get :check, params: { link: link }

      response.status.should eq(204)
      response.body.should be_empty
    end

    it 'returns 404 when link doesn\' exist' do
      get :check, params: { link: 'nonexistent' }

      response.status.should eq(404)
      response.body.should be_empty
    end
  end
end
