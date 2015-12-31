require 'rails_helper'

RSpec.describe CafeQueries do
  include ActiveSupport::Testing::TimeHelpers
  let(:first_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:third_user) { create(:user) }
  let(:first_shift) { CafeShift.new(start: 7.days.ago, lp: 3, pass: 1, lv: 6) }
  let(:second_shift) { CafeShift.new(start: 7.days.ago, lp: 3, pass: 2, lv: 6) }
  let(:third_shift) { CafeShift.new(start: 7.days.ago, lp: 3, pass: 3, lv: 6) }

  before do
    travel_to Time.zone.local(2014, 03, 25, 8)
    # Travel back to the spring of 2014.
    # It is the end of the third study period
    first_shift.save!
    first_shift.build_cafe_worker(user: first_user).save!
  end

  after do
    travel_back
  end

  describe :working_users do
    before do
      second_shift.save!
      second_shift.build_cafe_worker(user: second_user).save!
    end

    it 'should give all working users' do
      CafeQueries.working_users(3, Time.zone.now).should
      include(first_user, second_user)
    end

    it 'should not give non working users' do
      CafeQueries.working_users(3, Time.zone.now).should_not include(third_user)
    end
  end

  describe :cafe_workers do
    before do
      second_shift.save!
      second_shift.build_cafe_worker(user: second_user).save!
    end

    it 'should give all working users' do
      workers = CafeQueries.cafe_workers(3, Time.zone.now)
      workers.should include(first_shift.cafe_worker, second_shift.cafe_worker)
      workers.count.should eq(2)
    end
  end

  describe :highscore do
    before do
      second_shift.save!
      second_shift.build_cafe_worker(user: second_user).save!

      third_shift.save!
      third_shift.build_cafe_worker(user: second_user).save!
    end

    it 'should give all working users' do
      highscore = CafeQueries.highscore(3, Time.zone.now)

      highscore.first.id.should eq(second_user.id)
      highscore.first[:score].should eq(2)
      highscore.length.should eq(2)
    end
  end

  describe :free_shifts do
    it 'should give free shift' do
      # Prepare
      free_shift = CafeShift.new(start: 2.days.from_now, lp: 3, pass: 3, lv: 7)
      free_shift.save!

      # Query
      free = CafeQueries.free_shifts(3, Time.zone.now)

      # Should
      free.should include(free_shift)
      free.count.should eq(1)
      free.should_not include(first_shift)
    end

    it 'should not contain old free shift' do
      # Prepare
      old_free_shift = CafeShift.new(start: 2.days.ago, lp: 3, pass: 3, lv: 7)
      old_free_shift.save!

      # Query
      free = CafeQueries.free_shifts(3, Time.zone.now)

      # Should
      free.count.should eq(0)
      free.should_not include(old_free_shift)
    end

    it 'should not contain shift with worker' do
      # Query
      free = CafeQueries.free_shifts(3, Time.zone.now)

      # Should
      free.should_not include(first_shift)
    end
  end
end
