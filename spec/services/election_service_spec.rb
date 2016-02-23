require 'rails_helper'

RSpec.describe ElectionService do
  describe :create_candidate do
    it 'creates a valid candidate' do
      election = create(:election, :during, semester: Post::AUTUMN)
      current_user = create(:user)
      post = create(:post, semester: Post::AUTUMN)

      candidate = election.candidates.build(post: post)
      ElectionService.create_candidate(candidate, current_user).should be_truthy
    end
  end
end
