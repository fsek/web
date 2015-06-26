require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:group) { create(:group) }
  let(:valid_attr) { attributes_for(:group) }
  let(:invalid_attr) { attributes_for(:group, title: '') }
  let(:new_attr) { attributes_for(:group, title: 'Blåtand') }

  allow_user_to :manage, Group

  describe 'GET #index' do
    it 'assigns' do
      group
      get :index
      assigns(:groups).should include(group)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested group as @group' do
      get :show, id: group.to_param
      assigns(:group).should eq(group)
    end
  end

  describe 'GET #new' do
    it 'assigns a new group as @group' do
      get :new
      assigns(:group).should be_a_new(Group)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested group as @group' do
      get :edit, id: group.to_param
      assigns(:group).should eq(group)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Group' do
        lambda do
          post :create, group: valid_attr
        end.should change(Group, :count).by(1)
      end

      it 'assigns a newly created group as @group' do
        post :create, group: valid_attr
        assigns(:group).should be_a(Group)
        assigns(:group).should be_persisted
      end

      it 'redirects to the created group' do
        post :create, group: valid_attr
        response.should redirect_to(Group.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved group as @group' do
        post :create, group: invalid_attr
        assigns(:group).should be_a_new(Group)
      end

      it 're-renders the 'new' template' do
        post :create, group: invalid_attr
        response.should render_template('new')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested group' do
        patch :update, id: group.to_param, group: new_attr
        group.reload
        group.title.should eq(new_attr[:title])
      end

      it 'assigns the requested group as @group' do
        patch :update, id: group.to_param, group: valid_attr
        assigns(:group).should eq(group)
      end

      it 'redirects to the group' do
        patch :update, id: group.to_param, group: valid_attr
        response.should redirect_to(group)
      end
    end

    context 'with invalid params' do
      it 'assigns the group as @group' do
        patch :update, id: group.to_param, group: invalid_attr
        assigns(:group).should eq(group)
      end

      it 're-renders the "edit" template' do
        patch :update, id: group.to_param, group: invalid_attr
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      group
    end

    it 'destroys the requested group' do
      lambda do
        delete :destroy, id: group.to_param
      end.should change(Group, :count).by(-1)
    end

    it 'redirects to the groups list' do
      delete :destroy, id: group.to_param
      response.should redirect_to(groups_path)
    end
  end
end
