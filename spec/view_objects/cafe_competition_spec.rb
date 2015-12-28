require 'rails_helper'

describe CafeCompetition do
  create(:user)
  create(:user)
  first_shift = CafeShift.new(start: Time.zone.now - 5.days, lp: 3, pass: 1, lv: 1)
  first_shift.save!
  second_shift = CafeShift.new(start: Time.zone.now - 5.days, lp: 3, pass: 2, lv: 1)
  second_shift.save!
  first_shift.build_cafe_worker(user: User.first).save!
  second_shift.build_cafe_worker(user: User.last).save!
  cafe_comp = CafeCompetition.new(CafeWorker.all, User.all, '3', Time.zone.now)

  describe :attributes do
    it 'should give workers' do
      cafe_comp.cafe_workers.should eq(CafeWorker.all)
    end

    it 'should give users' do
      cafe_comp.users.should eq(User.all)
    end

    it 'should give lp' do
      cafe_comp.lp.should eq('3')
    end

    it 'should give lps' do
      cafe_comp.lps.should eq(['1', '2', '4'])
    end

    it 'should give year' do
      cafe_comp.year.should eq(Time.zone.now.year)
    end

    it 'should give years' do
      cafe_comp.years.should
      eq((2015..Time.zone.now.year + 1).to_a - [Time.zone.now.year])
    end
  end

  describe :methods do
    it 'should give count of cafe workers' do
      cafe_comp.count.should eq(CafeWorker.count)
    end

    it 'should give user count' do
      cafe_comp.user_count.should eq(User.count)
    end
  end
end
