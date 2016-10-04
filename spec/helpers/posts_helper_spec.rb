require 'rails_helper'

RSpec.describe PostHelper do
  describe 'print_post_limit' do
    it 'star' do
      position = build_stubbed(:post, rec_limit: 0, limit: 0)
      helper.print_post_limit(position).should eq('*')

      position.rec_limit = 5
      position.limit = 1
      helper.print_post_limit(position).should eq('*')
    end

    it '(x)' do
      position = build_stubbed(:post, rec_limit: 2, limit: 2)
      helper.print_post_limit(position).should eq('2 (x)')
    end

    it 'recommended' do
      position = build_stubbed(:post, rec_limit: 0, limit: 5)
      helper.print_post_limit(position).should eq(5)
    end

    it 'interval' do
      position = build_stubbed(:post, rec_limit: 3, limit: 5)
      helper.print_post_limit(position).should eq('3 - 5')
    end
  end
end
