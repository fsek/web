require 'rails_helper'

describe MailAliasesController, :type => :controller do
  describe '#index' do
    allow_user_to :manage, MailAlias
    it 'doesn\'t crash when requesting index' do
      get :index
      response.status.should == 200
    end

    it 'presents the correct list for an example query' do
      m = create(:mail_alias,
                 username: 'boss',
                 domain: 'fsektionen.se',
                 target: 'johan@forberg.se')

      get :search, format: :json, params: { q: 'boss' }

      response.status.should == 200
      assigns(:aliases).should == [ m ]
    end
  end

  describe '#update' do
    allow_user_to :manage, MailAlias

    it 'can destroy records' do
      c = create :mail_alias
      attributes = { username: c.username, domain: c.domain, targets: [] }

      put :update, format: :json, params: { mail_alias: attributes }

      response.status.should == 200
      MailAlias.count.should == 0
      assigns(:aliases).should == []
    end
  end
end
