require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a valid factory' do
    (build(:post)).should be_valid
  end

  let(:council) { create(:council)}
  let(:user) { create(:user)}
  let(:post) { create(:post, council: council) }
  let(:permission) { create(:permission) }
  subject { build(:post, council: council) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { should validate_presence_of(:limit) }
    it { should validate_presence_of(:recLimit) }
    it { should validate_presence_of(:description) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { should belong_to(:council) }
    it { should have_and_belong_to_many(:profiles) }
    it { should have_and_belong_to_many(:elections) }
    it { should have_many(:nominations) }
    it { should have_many(:candidates) }
    it { should have_many(:permissions) }
    it { should have_many(:permission_posts) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:to_s) }
      it { should respond_to(:printLimit) }
      it { should respond_to(:limited?) }
      it { should respond_to(:add_profile) }
      it { should respond_to(:remove_profile) }
      it { should respond_to(:set_permissions) }
    end

    context 'executes methods correctly' do
      context 'valid parameters' do
        it 'add_profile' do
          post.add_profile(user.profile).should be_truthy

          post.errors[:profile].should be_empty
          post.profiles.should include(user.profile)
        end

        it 'remove_profile' do
          post.profiles << user.profile

          post.remove_profile(user.profile).should be_truthy
          post.profiles.should_not include(user.profile)
        end

        it 'set_permissions' do
          post.set_permissions(permission_ids: [permission.id])

          post.permissions.should include(permission)
        end
      end
      context 'invalid parameters' do
        it 'add_profile' do
          post.add_profile(nil).should be_falsey
          post.errors[:profile].should_not be_empty

          post.profiles << user.profile
          post.add_profile(user.profile).should be_falsey
          post.errors[:profile].should_not be_empty
        end
      end
    end
  end
end
