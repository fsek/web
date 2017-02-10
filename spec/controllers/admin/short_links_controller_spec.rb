require 'rails_helper'

RSpec.describe Admin::ShortLinksController, type: :controller do
  allow_user_to(:manage, ShortLink)

  describe '#index' do
    it 'renders page succesfully' do
      create(:short_link, link: 'test')
      get(:index)

      response.status.should eq(200)
      assigns(:short_links).map(&:link).should eq(['test'])
    end
  end

  describe '#create' do
    allow_user_to :manage, ShortLink
    it 'creates new shortlink for new link' do
      sl = build :short_link

      post :create, params: { short_link: sl.attributes }

      response.status.should eq(302)

      created_sl = ShortLink.last
      created_sl.link.should eq(sl.link)
      created_sl.target.should eq(sl.target)
    end

    it 'updates old shortlink for old link' do
      old_sl = create :short_link
      new_sl = build :short_link, target: 'newurl.com'

      post :create, params: { short_link: new_sl.attributes }

      response.status.should eq(302)

      ShortLink.count.should eq(1)
      created_sl = ShortLink.last
      created_sl.target.should eq(new_sl.target)
    end
  end

  describe '#destroy' do
    it 'removes short_link' do
      short_link = create(:short_link)
      lambda do
        delete :destroy, params: { id: short_link.to_param }
      end.should change(ShortLink, :count).by(-1)

      response.should redirect_to(admin_short_links_path)
    end
  end
end
