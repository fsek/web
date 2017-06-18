require 'rails_helper'

RSpec.describe Admin::DoorsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Door)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a door grid and doors' do
      create(:door, title: 'First door')
      create(:door, title: 'Second door')
      create(:door, title: 'Third door')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given door as @door' do
      door = create(:door)

      get :edit, params: { id: door.to_param }
      assigns(:door).should eq(door)
    end
  end

  describe 'GET #new' do
    it 'assigns a new door as @door' do
      get(:new)
      assigns(:door).should be_a_new(Door)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title: 'Kategori 1',
                     slug: 'kategori',
                     description: 'En beskrivning' }

      lambda do
        post :create, params: { door: attributes }
      end.should change(Door, :count).by(1)

      response.should redirect_to(edit_admin_door_path(Door.last))
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { door: { title: '' } }
      end.should change(Door, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      door = create(:door, title: 'A Bad Title')

      attributes = { title: 'A Good Title' }
      patch :update, params: { id: door.to_param, door: attributes }
      door.reload

      response.should redirect_to(edit_admin_door_path(door))
    end

    it 'invalid parameters' do
      door = create(:door, title: 'A Good Title')

      attributes = { title: '' }
      patch :update, params: { id: door.to_param, door: attributes }
      door.reload

      door.title.should eq('A Good Title')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      door = create(:door)

      lambda do
        delete :destroy, params: { id: door.to_param }
      end.should change(Door, :count).by(-1)

      response.should redirect_to(admin_doors_path)
    end
  end
end
