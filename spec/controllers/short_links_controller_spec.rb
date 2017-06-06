require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  allow_user_to(:manage, ShortLink)

  describe '#go' do
    it 'redirects to the link when present' do
      link = 'hej'
      target = 'http://hej.se'
      sl = create(:short_link, link: link, target: target)

      get(:go, link: link)

      response.status.should == 301
      response.location.should == sl.target
    end

    it 'throws 404 when link is not found' do
      lambda do
        get(:go, link: 'nonexistent')
      end.should raise_error ActionController::RoutingError
    end
  end

  describe '#check' do
    it 'returns 204 when link exists' do
      link = 'testlink'
      create :short_link, link: link

      get :check, link: link

      response.status.should == 204
      response.body.should be_empty
    end

    it 'returns 404 when link doesn\' exist' do
      get :check, link: 'nonexistent'

      response.status.should == 404
      response.body.should be_empty
    end
  end
end
