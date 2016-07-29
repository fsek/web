require 'rails_helper'

RSpec.describe Position, type: :model do
  it 'has a valid factory' do
    build(:position).should be_valid
  end

  let(:council) { create(:council) }
  let(:user) { create(:user) }
  let(:position) { create(:position, council: council) }
  let(:permission) { create(:permission) }
  subject { build(:position, council: council) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { should validate_presence_of(:limit) }
    it { should validate_presence_of(:rec_limit) }
    it { should validate_presence_of(:description) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { should belong_to(:council) }
    it { should have_many(:position_users) }
    it { should have_many(:users) }
    it { should have_many(:nominations) }
    it { should have_many(:candidates) }
    it { should have_many(:permissions) }
    it { should have_many(:permission_positions) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:to_s) }
      it { should respond_to(:limited?) }
      it { should respond_to(:set_permissions) }
    end

    context 'executes methods correctly' do
      context 'valid parameters' do
        it 'set_permissions' do
          position.set_permissions(permission_ids: [permission.id])

          position.permissions.should include(permission)
        end
      end
    end
  end
end
