require 'rails_helper'

RSpec.describe CafeQueries do
  include ActiveSupport::Testing::TimeHelpers
  before do
    travel_to Time.zone.local(2014, 03, 25, 8)
    # Travel back to the spring of 2014.
    # It is the end of the third study period
  end

  after do
    travel_back
  end

  def shift_with_worker(user:, pass: 1, lp: 3, start: 7.days.ago)
    if pass == 2
      start += 2.hours
    end 
    shift = shift(pass: pass, lp: lp, start: start)
    shift.build_cafe_worker(user: user).save!
    shift
  end

  def shift(pass: 1, lp: 3, start: 7.days.ago)
    shift = CafeShift.new(start: start, lp: lp, lv: 6, pass: pass)
    shift.save!
    shift
  end

  describe :working_users do
    it 'should give all working users' do
      first_user = create(:user, firstname: 'First')
      shift_with_worker(user: first_user, pass: 1)

      second_user = create(:user, firstname: 'Second')
      shift_with_worker(user: second_user, pass: 2)

      create(:user, firstname: 'Third')

      CafeQueries.working_users(3, Time.zone.now).map(&:firstname).should
      eq(['First', 'Second'])
    end
  end

  describe :cafe_workers do
    it 'should give all working users' do
      first_user = create(:user, firstname: 'First')
      first_shift = shift_with_worker(user: first_user, pass: 1)

      second_user = create(:user, firstname: 'Second')
      second_shift = shift_with_worker(user: second_user, pass: 2)

      workers = CafeQueries.cafe_workers(3, Time.zone.now)
      workers.map(&:id).should eq([first_shift.cafe_worker.id, second_shift.cafe_worker.id])
      workers.count.should eq(2)
    end
  end

  describe :highscore do
    it 'gives the highscore of working users' do
      first_user = create(:user, firstname: 'First')
      shift_with_worker(user: first_user, pass: 1)

      second_user = create(:user, firstname: 'Second')
      shift_with_worker(user: second_user, pass: 1)
      shift_with_worker(user: second_user, pass: 2)

      highscore = CafeQueries.highscore(3, Time.zone.now)

      highscore.first.id.should eq(second_user.id)
      highscore.first[:score].should eq(2)
      highscore.length.should eq(2)
    end
  end

  describe :free_shifts do
    before do
      first_shift = CafeShift.new(start: 7.days.ago, lp: 3, pass: 1, lv: 6)
      first_shift.save!

      first_user = create(:user, firstname: 'First')
      first_shift.build_cafe_worker(user: first_user).save!
    end

    it 'should give free shift' do
      free_shift = shift(pass: 1, start: 2.days.from_now)
      shift_with_worker(pass: 2, start: 2.days.from_now, user: create(:user))

      free = CafeQueries.free_shifts(3, Time.zone.now)

      free.map(&:id).should eq([free_shift.id])
      free.count.should eq(1)
    end

    it 'should not contain old free shift' do
      old_free_shift = shift(start: 2.days.ago)

      free = CafeQueries.free_shifts(3, Time.zone.now)

      free.count.should eq(0)
      free.should_not include(old_free_shift)
    end
  end
end
