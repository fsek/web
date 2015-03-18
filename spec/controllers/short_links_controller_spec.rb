require 'spec_helper'

describe ShortLinksController, :type => :controller do
  USER_WITH_ACCESS = User.new 
  USER_WITHOUT_ACCESS = User.new

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:get_commit).and_return(true)
  end

  describe '#go' do
    it 'redirects to the link when present' do
      link = 'hej'
      target = 'hej.se'
      sl = create :short_link, :link => link, :target => target

      get :go, :link => link

      response.should be_redirect
      response.status.should == 301
      response.location.should == sl.target
    end

    it 'throws 404 when link is not found' do
      -> do 
        get :go, :link => 'nonexistent'
      end.should raise_error ActionController::RoutingError
    end
  end

  describe '#check' do
    it 'returns 204 when link exists' do
      link = 'testlink'
      create :short_link, :link => link

      get :check, :link => link

      response.status.should == 204
      response.body.should be_empty
    end

    it 'returns 404 when link doesn\' exist' do
      get :check, :link => 'nonexistent'

      response.status.should == 404
      response.body.should be_empty
    end
  end

  describe '#create' do
    it 'creates new shortlink for new link' do
      fake_sign_in

      sl = build :short_link

      post :create, :short_link => sl.attributes

      response.should_not be_error

      created_sl = ShortLink.last
      created_sl.link.should == sl.link
      created_sl.target.should == sl.target
    end

    it 'updates old shortlink for old link' do
      fake_sign_in

      old_sl = create :short_link
      new_sl = build :short_link, :target => 'new_url.com'

      post :create, :short_link => new_sl.attributes

      response.should_not be_error

      ShortLink.count.should == 1
      created_sl = ShortLink.last
      created_sl.target.should == new_sl.target
    end
  end

  describe '#destroy' do
    # Bah I know this. It's probably correct.
  end
end
