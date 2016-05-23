require 'rails_helper'

RSpec.describe Admin::ExLinksController, type: :controller do
  let(:attr) { attributes_for(:ex_link) }
  let(:ex_link) { create(:ex_link) }

  let(:user) { create(:user) }
  allow_user_to :manage, ExLink

  describe 'GET #index' do
    it 'loads ex links index' do
      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested ex_link as @ex_link' do
      get(:show, id: ex_link.to_param)
      assigns(:ex_link).should eq(ex_link)
    end
  end

  describe 'GET #edit' do
    it 'should render edit page' do
      get(:edit, id: ex_link.to_param)
      response.code.should eq('200')
    end
  end

  describe 'PATCH #update ex_link' do
    it 'updates ex_link' do
      patch :update,
            id: ex_link.to_param,
            ex_link: { url: 'http://changedurl.com', active: false }
      ex_link.reload
      ex_link.url.should eq('http://changedurl.com')
      ex_link.active.should eq(false)
    end
  end

  describe 'check that method' do
    context 'expiration_check is correct for' do
      it :expired do
        e = create(:ex_link, :expired)
        e.active.should equal(true)
        get(:check_expired)
        e.reload
        e.active.should equal(false)
      end
    end

    context 'aliveness_check is correct for' do
      it :dead_link do
        e = create(:ex_link, :dead_link)
        e.active.should equal(true)
        get(:check_dead)
        e.reload
        e.active.should equal(false)
      end
    end
  end
end
