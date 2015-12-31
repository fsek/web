require 'rails_helper'

RSpec.describe PostUserService do
  let(:post_user) { build(:post_user) }

  describe :valid do
    it :create do
      PostUserService.create(post_user).should be_truthy
    end
  end

  describe :invalid do
    before :each do
      allow(post_user.post).to receive(:limited?) { true }
    end

    it :create do
      PostUserService.create(post_user).should be_falsey
    end
  end
end
