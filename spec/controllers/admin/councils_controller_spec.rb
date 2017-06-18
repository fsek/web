require 'rails_helper'

RSpec.describe Admin::CouncilsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Council)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a councils' do
      create(:council, title: 'Second')
      create(:council, title: 'First')
      create(:council, title: 'Third')

      get(:index)
      response.status.should eq(200)
      assigns(:council_grid).should be_present
    end
  end

  describe 'GET #new' do
    it 'assigns a new council as @council' do
      get(:new)
      assigns(:council).instance_of?(Council).should be_truthy
      assigns(:council).new_record?.should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'assigns given council as @council' do
      council = create(:council)

      get :edit, params: { id: council.to_param }
      assigns(:council).should eq(council)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title_sv: 'Prylmästeriet',
                     url: 'pryl' }

      lambda do
        post :create, params: { council: attributes }
      end.should change(Council, :count).by(1)

      response.should redirect_to(edit_admin_council_path(Council.last))
      Council.last.title.should eq('Prylmästeriet')
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { council: { title_sv: '' } }
      end.should change(Council, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      council = create(:council, title: 'A Bad Title')

      attributes = { title_sv: 'A Good Title' }
      patch :update, params: { id: council.to_param, council: attributes }
      council.reload

      response.should redirect_to(edit_admin_council_path(council))
      council.title.should eq('A Good Title')
    end

    it 'invalid parameters' do
      council = create(:council, title: 'A Good Title')

      attributes = { title_sv: '' }
      patch :update, params: { id: council.to_param, council: attributes }
      council.reload

      council.title.should eq('A Good Title')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroying' do
      council = create(:council)

      lambda do
        delete :destroy, params: { id: council.to_param }
      end.should change(Council, :count).by(-1)

      response.should redirect_to(admin_councils_path)
    end
  end
end
