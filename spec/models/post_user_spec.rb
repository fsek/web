require 'rails_helper'

RSpec.describe PostUser, type: :model do
  subject { build(:post_user) }

  it { should be_valid }

  describe 'ActiveModel validations' do
    # Basic validations
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:post_id) }
    it 'validates uniqueness' do
      should validate_uniqueness_of(:user_id).scoped_to(:post_id).
        with_message(I18n.t('posts.already_have_post'))
    end
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { should respond_to(:to_s) }
    end
  end
end
