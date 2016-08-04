require 'rails_helper'

RSpec.describe Introduction, type: :model do
  it 'have valid factory' do
    build_stubbed(:introduction).should be_valid
  end

  describe 'introduction week' do
    it 'gives introduction week for a date' do
      date = Time.current.beginning_of_week
      introduction = build_stubbed(:introduction, start: date)

      introduction.week(3.days.from_now).should eq(0)
      introduction.week(8.days.from_now).should eq(1)
      introduction.week(15.days.from_now).should eq(2)
    end

    it 'gives introduction week for an integer' do
      date = Time.current.beginning_of_week
      week = date.to_date.cweek
      introduction = build_stubbed(:introduction, start: date)

      introduction.week(week).should eq(0)
      introduction.week(week + 77).should eq(77)
    end
  end
end
