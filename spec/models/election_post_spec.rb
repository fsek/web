require 'rails_helper'

RSpec.describe ElectionPost, type: :model do
  it 'has a valid factory' do
    build_stubbed(:election_post).should be_valid
  end
  subject { ElectionPost.new }

  it { should belong_to(:election) }
  it { should belong_to(:post) }

  it { should validate_presence_of(:election) }
  it { should validate_presence_of(:post) }

  it 'validates uniqueness of post and election' do
    post = create(:post)
    election = create(:election)

    election_post = ElectionPost.new(post: post, election: election)
    election_post.should be_valid

    election_post.save!
    ElectionPost.new(post: post, election: election).should be_invalid
  end
end
