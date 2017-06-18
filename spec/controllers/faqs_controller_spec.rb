require 'rails_helper'

RSpec.describe FaqsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to([:new, :create, :index], Faq)

  before(:each) do
    controller.stub(:current_user).and_return(user)
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

  describe 'GET #new' do
    it 'assigns new faq as @faq' do
      get(:new)

      response.status.should eq(200)
      assigns(:faq).new_record?.should be_truthy
      assigns(:faq).instance_of?(Faq).should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { question: 'Vem var Hilbert?' }

      lambda do
        post :create, params: { faq: attributes }
      end.should change(Faq, :count).by(1)

      response.should redirect_to(faqs_path)
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { faq: { question: '' } }
      end.should change(Faq, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end
end
