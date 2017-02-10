require 'rails_helper'

describe Admin::MailAliasesController, type: :controller do
  describe '#index' do
    allow_user_to :manage, MailAlias
    it 'doesn\'t crash when requesting index' do
      get :index
      response.status.should eq(200)
    end

    it 'presents the correct list for an example query' do
      m = create(:mail_alias,
                 username: 'boss',
                 domain: 'fsektionen.se',
                 target: 'johan@forberg.se')

      get :search, format: :json, params: { q: 'boss' }

      response.status.should eq(200)
      assigns(:aliases).should eq([m])
    end
  end

  describe '#update' do
    allow_user_to :manage, MailAlias

    it 'can destroy records' do
      c = create :mail_alias
      attributes = { username: c.username, domain: c.domain, targets: [] }

      put :update, format: :json, params: { mail_alias: attributes }

      response.status.should eq(200)
      MailAlias.count.should eq(0)
      assigns(:aliases).should eq([])
    end
  end
end
