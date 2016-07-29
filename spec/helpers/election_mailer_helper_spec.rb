require 'rails_helper'

RSpec.describe ElectionMailerHelper do
  describe 'candidate_mail_link' do
    it 'not a board position' do
      election = build_stubbed(:election, board_mail_link: 'http://board.com',
                                          mail_link: 'http://normal.com')
      position = build_stubbed(:position, board: false)
      candidate = build_stubbed(:candidate, election: election, position: position)

      result = helper.candidate_mail_link(candidate)

      result.should eq('http://normal.com')
    end

    it 'a board position' do
      election = build_stubbed(:election, board_mail_link: 'http://board.com',
                                          mail_link: 'http://normal.com')
      position = build_stubbed(:position, board: true)
      candidate = build_stubbed(:candidate, election: election, position: position)

      result = helper.candidate_mail_link(candidate)

      result.should eq('http://board.com')
    end

    it 'returns nil if no candidate' do
      result = helper.candidate_mail_link(nil)

      result.should be_nil
    end
  end
end
