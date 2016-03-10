require 'rails_helper'

RSpec.describe Nomination, type: :model do
  describe 'validations' do
    it 'checks presence of name' do
      nomination = Nomination.new

      nomination.should validate_presence_of(:name)
    end

    it 'checks presence of email' do
      nomination = Nomination.new

      nomination.should validate_presence_of(:email)
    end

    it 'checks presence of post_id' do
      nomination = Nomination.new

      nomination.should validate_presence_of(:post_id)
    end

    it 'checks email format' do
      nomination = Nomination.new

      nomination.should allow_value('hilbert911.1@fsektionen.se').for(:email)
      nomination.should_not allow_value('hilbert').for(:email)
      nomination.should_not allow_value('hilbert@fsektionen').for(:email)
      nomination.should_not allow_value('@fsektionen.se').for(:email)
    end
  end

  describe 'public methods' do
    it 'has candidate_url' do
      nomination = build_stubbed(:nomination)
      post = nomination.post

      nomination.candidate_url.should eq(new_candidate_url(post: post.id, host: PUBLIC_URL))
    end
  end
end
