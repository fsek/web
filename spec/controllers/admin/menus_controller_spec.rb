require 'rails_helper'

RSpec.describe Admin::MenusController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, Menu)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a menu grid and categories' do
      create(:menu)

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given menu as @menu' do
      menu = create(:menu)

      get :edit, params: { id: menu.to_param }
      assigns(:menu).should eq(menu)
    end
  end

  describe 'GET #new' do
    it 'assigns a new menu as @menu' do
      get(:new)
      assigns(:menu).instance_of?(Menu).should be_truthy
      assigns(:menu).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      main = create(:main_menu)
      attributes = { name_sv: 'Bildgalleri',
                     main_menu_id: main.id,
                     index: 1337,
                     link: '/galleri',
                     visible: true,
                     turbolinks: false,
                     blank_p: false }

      lambda do
        post :create, params: { menu: attributes }
      end.should change(Menu, :count).by(1)

      response.should redirect_to(admin_menus_path)
      Menu.last.name.should eq('Bildgalleri')
    end

    it 'invalid parameters' do
      lambda do
        post :create, params: { menu: { name_sv: '' } }
      end.should change(Menu, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      menu = create(:menu, name: 'Aftonbladet')

      attributes = { name_sv: 'Bildgalleri' }
      patch :update, params: { id: menu.to_param, menu: attributes }
      menu.reload

      response.should redirect_to(edit_admin_menu_path(menu))
      menu.name.should eq('Bildgalleri')
    end

    it 'invalid parameters' do
      menu = create(:menu, name: 'Bildgalleri')

      attributes = { name_sv: '' }
      patch :update, params: { id: menu.to_param, menu: attributes }
      menu.reload

      menu.name.should eq('Bildgalleri')
      response.status.should eq(422)
      response.should render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      menu = create(:menu)

      lambda do
        delete :destroy, params: { id: menu.to_param }
      end.should change(Menu, :count).by(-1)

      response.should redirect_to(admin_menus_path)
    end
  end
end
