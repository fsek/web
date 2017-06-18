require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Category)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a category grid and categories' do
      create(:category, title: 'First category')
      create(:category, title: 'Second category')
      create(:category, title: 'Third category')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given category as @category' do
      category = create(:category)

      get :edit, params: { id: category.to_param }
      assigns(:category).should eq(category)
    end
  end

  describe 'GET #new' do
    it 'assigns a new category as @category' do
      get(:new)
      assigns(:category).instance_of?(Category).should be_truthy
      assigns(:category).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title_sv: 'Kategori 1', slug: 'kategori' }

      lambda do
        post :create, params: { category: attributes }
      end.should change(Category, :count).by(1)

      response.should redirect_to(admin_categories_path)
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { category: { slug: '' } }
      end.should change(Category, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      category = create(:category, title_en: 'A Bad Title')

      patch :update, params: { id: category.to_param, category: { title_en: 'A Good Title' } }
      category.reload

      category.title_en.should eq('A Good Title')
      response.should redirect_to(edit_admin_category_path(category))
    end

    it 'invalid parameters' do
      category = create(:category, slug: 'good')

      patch :update, params: { id: category.to_param, category: { slug: '' } }
      category.reload

      category.slug.should eq('good')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      category = create(:category)

      lambda do
        delete :destroy, params: { id: category.to_param }
      end.should change(Category, :count).by(-1)

      response.should redirect_to(admin_categories_path)
    end
  end
end
