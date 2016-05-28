require 'rails_helper'

RSpec.describe PostUser.new, type: :model do
  let(:post_user) { build_stubbed(:post_user) }

  it { post_user.should be_valid }

  describe 'ActiveModel validations' do
    # Basic validations
    it { PostUser.new.should validate_presence_of(:user_id) }
    it { PostUser.new.should validate_presence_of(:post_id) }
    it 'validates uniqueness' do
      PostUser.new.should validate_uniqueness_of(:user_id).scoped_to(:post_id).
        with_message(I18n.t('model.post_user.already_have_post'))
    end
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { PostUser.new.should belong_to(:post) }
    it { PostUser.new.should belong_to(:user) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { post_user.should respond_to(:to_s) }
    end
  end
end
