require 'rails_helper'
RSpec.describe Admin::IntroductionsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, Introduction)

  describe 'GET #index' do
    it 'renders index successfully' do
      create(:introduction)
      create(:introduction)

      get(:index)
      response.should have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'renders successfully' do
      get(:new)
      response.should have_http_status(200)
      assigns(:introduction).should be_a_new(Introduction)
    end
  end

  describe 'GET #edit' do
    it 'renders sucessfully' do
      introduction = create(:introduction, slug: 'spindel')

      get :edit, params: { id: 'spindel' }
      response.should have_http_status(200)
      assigns(:introduction).should eq(introduction)
    end
  end

  describe 'POST #create' do
    it 'successful with valid params' do
      attributes = { title_sv: 'Spindelnollning', title_en: 'Spider introduction',
                     slug: :spindel, start: 10.days.from_now,
                     stop: 37.days.from_now, description: 'Spindlarna kommer!' }

      lambda do
        post :create, params: { introduction: attributes }
      end.should change(Introduction, :count).by(1)
      response.should redirect_to(edit_admin_introduction_path(Introduction.last))
    end

    it 'unsuccessful with invalid params' do
      attributes = { title_sv: 'Spindelnollning - not enough' }

      lambda do
        post :create, params: { introduction: attributes }
      end.should change(Introduction, :count).by(0)
      response.should have_http_status(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'successful with valid params' do
      introduction = create(:introduction, title_sv: 'Piratnollning')
      attributes = { title_sv: 'Spindelnollning' }

      patch :update, params: { id: introduction.to_param, introduction: attributes }

      introduction.reload
      response.should redirect_to(edit_admin_introduction_path(Introduction.last))
      introduction.title_sv.should eq('Spindelnollning')
    end

    it 'unsuccessful with invalid params' do
      introduction = create(:introduction, title_sv: 'Spindelnollning')
      attributes = { title_sv: nil }

      patch :update, params: { id: introduction.to_param, introduction: attributes }

      introduction.reload
      introduction.title_sv.should eq('Spindelnollning')
      response.should have_http_status(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes introduction' do
      introduction = create(:introduction)

      lambda do
        delete :destroy, params: { id: introduction.to_param }
      end.should change(Introduction, :count).by(-1)
      response.should redirect_to(admin_introductions_path)
    end
  end
end
