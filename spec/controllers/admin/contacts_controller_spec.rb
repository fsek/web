require 'rails_helper'

RSpec.describe Admin::ContactsController, type: :controller do
  allow_user_to :manage, Contact

  describe 'GET #index' do
    it 'succeeds and assigns contacts' do
      create(:contact, name: 'Second')
      create(:contact, name: 'Third')
      create(:contact, name: 'First')

      get :index

      response.should be_success
    end
  end

  describe 'GET #new' do
    it 'succeeds' do
      get :new

      response.should be_success
      assigns(:contact).new_record?.should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'succeeds' do
      contact = create(:contact)

      get :edit, params: { id: contact.to_param }

      response.should be_success
      assigns(:contact).should eq(contact)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      attributes = { name_sv: 'David',
                     email: 'test@test.se',
                     public: 1,
                     text_sv: 'Jag kan svara på mejl' }

      lambda do
        post :create, params: { contact: attributes }
      end.should change(Contact, :count).by(1)

      response.should redirect_to(edit_admin_contact_path(Contact.last))
      Contact.last.name.should eq('David')
    end

    it 'invalid params' do
      lambda do
        post :create, params: { contact: { name_sv: nil } }
      end.should change(Contact, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      contact = create(:contact, name: 'David')

      post :update, params: { id: contact.to_param, contact: { name_sv: 'Titel' } }

      contact.reload
      response.should redirect_to(edit_admin_contact_path(contact))

      contact.name.should eq('Titel')
    end

    it 'valid params' do
      contact = create(:contact, name: 'David')
      post :update, params: { id: contact.to_param, contact: { name_sv: '' } }
      contact.reload

      contact.name.should eq('David')
      response.should render_template(:edit)
      response.status.should eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'succeeds' do
      contact = create(:contact)

      lambda do
        delete :destroy, params: { id: contact.to_param }
      end.should change(Contact, :count).by(-1)

      response.should redirect_to(admin_contacts_path)
    end
  end
end
