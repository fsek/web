require 'rails_helper'

RSpec.describe ElectionMailerHelper do
  describe 'candidate_mail_link' do
    it 'not a board post' do
      election = build_stubbed(:election, board_mail_link: 'http://board.com',
                                          mail_link: 'http://normal.com')
      postt = build_stubbed(:post, board: false)
      candidate = build_stubbed(:candidate, election: election, post: postt)

      result = helper.candidate_mail_link(candidate)

      result.should eq('http://normal.com')
    end

    it 'a board post' do
      election = build_stubbed(:election, board_mail_link: 'http://board.com',
                                          mail_link: 'http://normal.com')
      postt = build_stubbed(:post, board: true)
      candidate = build_stubbed(:candidate, election: election, post: postt)

      result = helper.candidate_mail_link(candidate)

      result.should eq('http://board.com')
    end

    it 'returns nil if no candidate' do
      result = helper.candidate_mail_link(nil)

      result.should be_nil
    end
  end
end
