require 'rails_helper'
RSpec.describe ContactsController, type: :controller do
  let(:attr) { attributes_for(:contact) }

  context 'when allowed to manage contacts' do
    allow_user_to :manage, Contact

    describe 'POST #create new contact' do
      it 'creates a new candidate' do
        lambda do
          post :create, contact: attr
        end.should change(Contact, :count).by(1)
      end

      it 'creates candidate and redirects to candidate' do
        post :create, contact: attr
        response.should redirect_to(contact_path(Contact.last))
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
  end
end
