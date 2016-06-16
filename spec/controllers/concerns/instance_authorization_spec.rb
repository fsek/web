require 'rails_helper'

# Dummy class for testing instance_authorization module
class Instance
  include InstanceAuthorization

  def current_user
    nil
  end
end

describe InstanceAuthorization, type: :concern do
  let(:instance) { Instance.new }
  subject { instance }

  describe '#current_ability' do
    it 'returns and assigns current_ability' do
      user = build_stubbed(:user)
      instance.stub(:current_user) { user }
      ability = Ability.new(user)
      Ability.stub(:new).with(user) { ability }

      instance.current_ability.should eq(ability)
      instance.instance_variable_get(:@current_ability).should eq(ability)
    end
  end

  describe '#current_admin_ability' do
    it 'returns and assigns current_admin_ability' do
      user = build_stubbed(:user)
      instance.stub(:current_user) { user }
      ability = AdminAbility.new(user)
      AdminAbility.stub(:new).with(user) { ability }

      instance.current_admin_ability.should eq(ability)
      instance.instance_variable_get(:@current_admin_ability).should eq(ability)
    end
  end

  describe '#load_permissions' do
    it 'returns nil if no current_user' do
      instance.stub(:current_user) { nil }
      instance.load_permissions.should be_nil
    end

    it 'returns and assigns current_permissions' do
      user = build_stubbed(:user)
      instance.stub(:current_user) { user }
      permissions = []
      permissions << Permission.new(subject_class: 'user', action: 'create')
      permissions << Permission.new(subject_class: 'instance', action: 'manage')

      user.stub(:permissions) { permissions }
      result = [%w(user create), %w(instance manage)]

      instance.load_permissions.should eq(result)
      instance.instance_variable_get(:@current_permissions).should eq(result)
    end
  end

  describe '#can_administrate?' do
    it 'returns true from can?' do
      instance.current_admin_ability.stub(:can?) { true }
      instance.can_administrate?(Instance, :manage).should be_truthy
    end

    it 'returns false from can?' do
      instance.current_admin_ability.stub(:can?) { false }
      instance.can_administrate?(Instance, :manage).should be_falsey
    end
  end

  describe '#authorize_admin!' do
    it 'returns response from authorize!' do
      instance.current_admin_ability.stub(:authorize!) { 'YES YOU CAN' }
      instance.authorize_admin!(Instance, :manage).should eq('YES YOU CAN')
      instance.instance_variable_get(:@_authorized).should be_truthy
    end

    it 'returns response of can?' do
      instance.current_admin_ability.stub(:authorize!) { 'NO YOU CANNOT' }
      instance.authorize_admin!(Instance, :manage).should eq('NO YOU CANNOT')
      instance.instance_variable_get(:@_authorized).should be_truthy
    end
  end
end
