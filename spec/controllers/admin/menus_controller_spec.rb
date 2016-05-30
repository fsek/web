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

      get(:edit, id: menu.to_param)
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
      attributes = { name_sv: 'Bildgalleri',
                     location: 'guild',
                     index: 1337,
                     link: '/galleri',
                     visible: true,
                     turbolinks: false,
                     blank_p: false }

      lambda do
        post :create, menu: attributes
      end.should change(Menu, :count).by(1)

      response.should redirect_to(admin_menus_path)
      Menu.last.name.should eq('Bildgalleri')
    end

    it 'invalid parameters' do
      lambda do
        post :create, menu: { name_sv: '' }
      end.should change(Menu, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      menu = create(:menu, name: 'Aftonbladet')

      patch :update, id: menu.to_param, menu: { name_sv: 'Bildgalleri' }
      menu.reload

      response.should redirect_to(edit_admin_menu_path(menu))
      menu.name.should eq('Bildgalleri')
    end

    it 'invalid parameters' do
      menu = create(:menu, name: 'Bildgalleri')

      patch :update, id: menu.to_param, menu: { name_sv: '' }
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
        delete :destroy, id: menu.to_param
      end.should change(Menu, :count).by(-1)

      response.should redirect_to(admin_menus_path)
    end
  end
end
