require 'rails_helper'

RSpec.describe Admin::FaqsController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Faq)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a faq grid and categories' do
      create(:faq, question: 'First faq')
      create(:faq, question: 'Second faq')
      create(:faq, question: 'Third faq')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given faq as @faq' do
      faq = create(:faq)

      get :edit, params: { id: faq.to_param }
      assigns(:faq).should eq(faq)
    end
  end

  describe 'GET #new' do
    it 'assigns a new faq as @faq' do
      get(:new)
      assigns(:faq).instance_of?(Faq).should be_truthy
      assigns(:faq).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { question: 'Vem är Hilbert?',
                     answer: 'Han är en älg!',
                     category: 'Hilbert Café' }

      lambda do
        post :create, params: { faq: attributes }
      end.should change(Faq, :count).by(1)

      response.should redirect_to(edit_admin_faq_path(Faq.last))
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { faq: { question: '' } }
      end.should change(Faq, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      faq = create(:faq, question: 'A Bad Question')

      attributes = { question: 'A Good Question' }
      patch :update, params: { id: faq.to_param, faq: attributes }
      faq.reload

      response.should redirect_to(edit_admin_faq_path(faq))
      faq.question.should eq('A Good Question')
    end

    it 'invalid parameters' do
      faq = create(:faq, question: 'A Good Question')

      attributes = { question: '' }
      patch :update, params: { id: faq.to_param, faq: attributes }
      faq.reload

      faq.question.should eq('A Good Question')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      faq = create(:faq)

      lambda do
        delete :destroy, params: { id: faq.to_param }
      end.should change(Faq, :count).by(-1)

      response.should redirect_to(admin_faqs_path)
    end
  end
end
