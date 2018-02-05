require 'rails_helper'

RSpec.describe CafeShift, type: :model do
  let(:shift) { build_stubbed(:cafe_shift) }
  let(:with_worker) { build_stubbed(:cafe_shift, :with_worker) }
  it 'has a valid factory' do
    shift.should be_valid
  end

  describe 'ActiveModel validations' do
    # Basic validations
    it { CafeShift.new.should validate_presence_of(:start) }
    it { CafeShift.new.should validate_presence_of(:pass) }
    it { CafeShift.new.should validate_presence_of(:lp) }
    it { CafeShift.new.should validate_presence_of(:lv) }
    it { CafeShift.new.should validate_inclusion_of(:pass).in_range(1..2)}
    it { CafeShift.new.should validate_inclusion_of(:lp).in_range(1..4) }
    it { CafeShift.new.should validate_inclusion_of(:lv).in_range(0..8) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { CafeShift.new.should have_one(:user) }
    it { CafeShift.new.should have_one(:cafe_worker) }
  end

  # This tests makes sure that dates are formatted into ISO8601 for
  # Fullcalendars json-feed
  # Ref.: https://github.com/fsek/web/issues/99
  describe :json do
    it 'check date format is iso8601' do
      shift.as_json.to_json.should include(shift.start.iso8601.to_json)
      shift.as_json.to_json.should include(shift.stop.iso8601.to_json)
    end

    it 'green color if checked by worker' do
      with_worker.as_json(user: with_worker.user)[:backgroundColor].should eq('green')
    end

    it 'orange color if checked by other' do
      with_worker.as_json[:backgroundColor].should eq('orange')
    end

    it 'white color if no worker' do
      shift.as_json[:backgroundColor].should eq('white')
      shift.as_json(user: with_worker.user)[:backgroundColor].should eq('white')
    end
  end
end
