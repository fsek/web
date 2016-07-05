require 'rails_helper'

RSpec.describe Admin::PermissionsController, type: :controller do
  allow_user_to(:manage, [Permission, PermissionPosition, Position])

  describe 'GET #index' do
    it 'assigns a permission grid and categories' do
      council = create(:council)
      create(:position, title: 'Bposition', council: council)
      position = create(:position, title: 'Aposition', council: council)
      create(:permission_position, position: position)

      get(:index)
      response.status.should eq(200)
      assigns(:positions).map(&:title).should eq(['Aposition', 'Bposition'])
    end
  end

  describe 'GET #show_position' do
    it 'assigns permissions as @permission, sorted by subject_class' do
      position = create(:position)
      create(:permission, name: 'Second', subject_class: 'tool')
      permission = create(:permission, name: 'First', subject_class: 'cafe')
      create(:permission_position, position: position, permission: permission)

      get(:show_position, position_id: position.to_param)
      assigns(:permissions).map(&:name).should eq(['First', 'Second'])
    end
  end

  describe 'PATCH #update_position' do
    it 'valid parameters' do
      position = create(:position)
      permission = create(:permission, name: 'Old')
      create(:permission_position, position: position, permission: permission)

      position.permissions.map(&:name).should eq(['Old'])

      other_permission = create(:permission, name: 'New')

      patch(:update_position, position_id: position.to_param,
                              position: { permission_ids: [other_permission.to_param] })

      response.should redirect_to(admin_permissions_path)
      position.reload

      position.permissions.map(&:name).should eq(['New'])
    end
  end
end
