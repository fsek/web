require 'rails_helper'

RSpec.describe Notice, type: :model do
  subject(:notice) { build(:notice) }
  describe :Validations do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sort) }
  end

  describe 'scopes' do
    it 'contains only published' do
      create(:notice, sort: 100, title: 'Second',
                      d_publish: 1.day.ago, d_remove: nil)
      create(:notice, sort: 50, title: 'First',
                      d_publish: 1.day.ago, d_remove: 5.days.from_now)
      create(:notice, sort: 1, title: 'Removed',
                      d_publish: 3.day.ago, d_remove: 1.day.ago)

      Notice.published.map(&:title).should eq(['First', 'Second'])
    end

    it 'contains only publik' do
      create(:notice, title: 'Public', public: true)
      create(:notice, title: 'Not public', public: false)

      Notice.publik.map(&:title).should eq(['Public'])
    end
  end
end
