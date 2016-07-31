require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  it 'has valid factory' do
    build_stubbed(:blog_post).should be_valid
  end

  describe '#to_param' do
    it 'formats title' do
      blog_post = BlogPost.new(id: 37, title: 'Detta är en title')
      blog_post.to_param.should eq('37-detta-ar-en-title')
    end
  end
end
