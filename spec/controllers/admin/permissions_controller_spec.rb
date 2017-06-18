require 'rails_helper'

RSpec.describe Admin::PermissionsController, type: :controller do
  allow_user_to(:manage, [Permission, PermissionPost, Post])

  describe 'GET #index' do
    it 'assigns a permission grid and categories' do
      council = create(:council)
      create(:post, title: 'Bpost', council: council)
      the_post = create(:post, title: 'Apost', council: council)
      create(:permission_post, post: the_post)

      get(:index)
      response.status.should eq(200)
      assigns(:posts).map(&:title).should eq(['Apost', 'Bpost'])
    end
  end

  describe 'GET #show_post' do
    it 'assigns permissions as @permission, sorted by subject_class' do
      the_post = create(:post)
      create(:permission, name: 'Second', subject_class: 'tool')
      permission = create(:permission, name: 'First', subject_class: 'cafe')
      create(:permission_post, post: the_post, permission: permission)

      get :show_post, params: { post_id: the_post.to_param }
      assigns(:permissions).map(&:name).should eq(['First', 'Second'])
    end
  end

  describe 'PATCH #update_post' do
    it 'valid parameters' do
      the_post = create(:post)
      permission = create(:permission, name: 'Old')
      create(:permission_post, post: the_post, permission: permission)

      the_post.permissions.map(&:name).should eq(['Old'])

      other_permission = create(:permission, name: 'New')

      post_attributes = { permission_ids: [other_permission.to_param] }
      patch :update_post, params: { post_id: the_post.to_param, post: post_attributes }

      response.should redirect_to(admin_permissions_path)
      the_post.reload

      the_post.permissions.map(&:name).should eq(['New'])
    end
  end
end
