require 'rails_helper'

RSpec.describe News, type: :model do
  it 'has valid factory' do
    build_stubbed(:news).should be_valid
  end

  it 'validates url format' do
    news = build_stubbed(:news)
    news.should allow_value('/nollning').for(:url)
    news.should allow_value('https://fsektionen.se/nollning').for(:url)
    news.should allow_value('http://google.se/nollning').for(:url)
    news.should_not allow_value('fsektionen.se/nollning').for(:url)
  end
end
