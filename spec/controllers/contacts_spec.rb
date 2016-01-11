require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  let(:contact) { create(:contact) }
  let(:attr) { attributes_for(:contact) }

  allow_user_to :manage, Contact

  describe 'POST #create' do
    it 'valid params' do
      lambda do
        post :create, contact: attr
      end.should change(Contact, :count).by(1)

      response.should redirect_to(contact_path(Contact.last))
    end

    it 'invalid params' do
      lambda do
        post :create, contact: { name: nil }
      end.should change(Contact, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      post :update, id: contact.to_param, contact: { name: 'Titel' }
      contact.reload
      response.should redirect_to(edit_contact_path(contact))

      contact.name.should eq('Titel')
    end

    it 'valid params' do
      post :update, id: contact.to_param, contact: { name: '' }
      contact.reload

      response.should render_template(:edit)
      response.status.should eq(422)
    end
  end

  describe 'GET #new' do
    it 'succeeds' do
      get :new

      response.should be_success
    end

    it 'prepares new candidate with user' do
      get :new

      assigns(:contact).new_record?.should be_truthy
    end
  end

  describe 'GET #index' do
    it 'succeeds' do
      get :index

      response.should be_success
    end

    it 'assigns users candidates' do
      get :index

      assigns(:contacts).should eq(Contact.all)
    end
  end

  describe 'GET #show' do
    it 'succeeds' do
      get :show, id: contact.to_param

      response.should be_success
      assigns(:contact).should eq(contact)
    end
  end

  describe 'GET #edit' do
    it 'succeeds' do
      get :edit, id: contact.to_param

      response.should be_success
      assigns(:contact).should eq(contact)
    end
  end
end
