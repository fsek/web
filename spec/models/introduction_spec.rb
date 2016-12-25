require 'rails_helper'

RSpec.describe Introduction, type: :model do
  it 'have valid factory' do
    build_stubbed(:introduction).should be_valid
  end

  describe 'introduction week' do
    it 'gives introduction week for a date, if same year' do
      date = Time.current.change(month: 8).beginning_of_week

      introduction = build_stubbed(:introduction, start: date)

      introduction.week(date + 3.days).should eq(0)
      introduction.week(date + 8.days).should eq(1)
      introduction.week(date + 15.days).should eq(2)
    end

    it 'returns nil if not same year' do
      date = Time.current.change(month: 12, day: 31).beginning_of_week

      introduction = build_stubbed(:introduction, start: date)

      introduction.week(date + 8.days).should be_nil
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
