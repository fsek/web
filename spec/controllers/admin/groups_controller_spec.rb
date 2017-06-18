require 'rails_helper'
RSpec.describe Admin::GroupsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Group)

  describe 'GET #index' do
    it 'renders index successfully' do
      create(:group)
      create(:group)

      get(:index)
      response.should have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'renders successfully' do
      get(:new)
      response.should have_http_status(200)
      assigns(:group).should be_a_new(Group)
    end
  end

  describe 'GET #edit' do
    it 'renders sucessfully' do
      group = create(:group)

      get :edit, params: { id: group.to_param }
      response.should have_http_status(200)
      assigns(:group).should eq(group)
    end
  end

  describe 'POST #create' do
    it 'successful with valid params' do
      introduction = create(:introduction)
      attributes = { introduction_id: introduction.id, name: 'Rock the Knight', number: 7 }

      lambda do
        post :create, params: { group: attributes }
      end.should change(Group, :count).by(1)
      response.should redirect_to(new_admin_group_path)
    end

    it 'unsuccessful with invalid params' do
      attributes = { number: 37 }

      lambda do
        post :create, params: { group: attributes }
      end.should change(Group, :count).by(0)
      response.should have_http_status(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'successful with valid params' do
      group = create(:group, name: 'En ogodtycklig grupp', number: 36)
      attributes = { name: 'En Godtycklig grupp', number: 37 }

      patch :update, params: { id: group.to_param, group: attributes }

      group.reload
      response.should redirect_to(admin_groups_path)
      group.name.should eq('En Godtycklig grupp')
      group.number.should eq(37)
    end

    it 'unsuccessful with invalid params' do
      group = create(:group, number: 37)
      attributes = { number: -1 }

      patch :update, params: { id: group.to_param, group: attributes }

      group.reload
      group.number.should eq(37)
      response.should have_http_status(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes group' do
      group = create(:group)

      lambda do
        delete :destroy, params: { id: group.to_param }
      end.should change(Group, :count).by(-1)
      response.should redirect_to(admin_groups_path)
    end
  end
end
