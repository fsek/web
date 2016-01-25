require 'rails_helper'

RSpec.describe Admin::DocumentsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Document)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a document grid and categories' do
      create(:document, title: 'First document')
      create(:document, title: 'Second document')
      create(:document, title: 'Third document')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given document as @document' do
      document = create(:document)

      get(:edit, id: document.to_param)
      assigns(:document).should eq(document)
    end
  end

  describe 'GET #new' do
    it 'assigns a new document as @document' do
      get(:new)
      assigns(:document).instance_of?(Document).should be_truthy
      assigns(:document).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = attributes_for(:document)

      lambda do
        post :create, document: attributes
      end.should change(Document, :count).by(1)

      response.should redirect_to(edit_admin_document_path(Document.last))
      # current_user is set and the document user should be set to this
      Document.last.user_id.should eq(user.id)
    end

    it 'invalid parameters' do
      lambda do
        post :create, document: { title: '' }
      end.should change(Document, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      document = create(:document, title: 'A Bad Title', user_id: 99)

      patch :update, id: document.to_param, document: { title: 'A Good Title' }
      document.reload

      response.should redirect_to(edit_admin_document_path(document))
      # current_user is set and the document user should be updated
      document.user_id.should eq(user.id)
    end

    it 'invalid parameters' do
      document = create(:document, title: 'A Good Title')

      patch :update, id: document.to_param, document: { title: '' }
      document.reload

      document.title.should eq('A Good Title')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      document = create(:document)

      lambda do
        delete :destroy, id: document.to_param
      end.should change(Document, :count).by(-1)

      response.should redirect_to(admin_documents_path)
    end
  end
end
