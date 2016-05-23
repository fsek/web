require 'rails_helper'

RSpec.describe ExLinksController, type: :controller do
  let(:attr) { attributes_for(:ex_link) }
  let(:ex_link) { create(:ex_link) }

  let(:user) { create(:user) }
  allow_user_to :manage, User

  describe 'GET #index' do
    it 'loads ex links index' do
      get(:index)
      response.status.should eq(302)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested ex_link as @ex_link' do
      get(:show, id: ex_link.to_param)
      assigns(:ex_link).should eq(ex_link)
    end
  end
end
