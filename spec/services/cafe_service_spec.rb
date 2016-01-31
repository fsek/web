require 'rails_helper'

RSpec.describe CafeService do
  describe :setup_week do
    it :valid_setup do
      cafe_shift = build(:cafe_shift, lv: 1)
      cafe_shift.pass = nil
      cafe_shift.lv_last = 3
      check = false

      lambda do
        check = CafeService.setup_week(cafe_shift)
      end.should change(CafeShift, :count).by(60)

      check.should be_truthy
    end

    it :invalid_setup do
      invalid_cafe_shift = build(:cafe_shift, start: nil, lv: 1)
      invalid_cafe_shift.pass = nil
      invalid_cafe_shift.lv_last = 3
      check = true
      lambda do
        check = CafeService.setup_week(invalid_cafe_shift)
      end.should change(CafeShift, :count).by(0)

      check.should be_falsey
    end
  end

  describe :setup_day do
    it :valid_setup do
      cafe_shift = build(:cafe_shift, lv: 1)
      cafe_shift.pass = nil
      check = false

      lambda do
        check = CafeService.setup_day(cafe_shift)
      end.should change(CafeShift, :count).by(4)

      check.should be_truthy
    end

    it :invalid_setup do
      invalid_cafe_shift = build(:cafe_shift, start: nil, lv: 1)
      invalid_cafe_shift.pass = nil
      check = true

      lambda do
        check = CafeService.setup_day(invalid_cafe_shift)
      end.should change(CafeShift, :count).by(0)

      check.should be_falsey
    end
  end

  describe :setup do
    it 'creates week' do
      cafe_shift = build(:cafe_shift, lv: 1)
      cafe_shift.pass = nil
      cafe_shift.lv_last = 3
      cafe_shift.setup_mode = 'week'
      check = false

      lambda do
        check = CafeService.setup(cafe_shift)
      end.should change(CafeShift, :count).by(60)

      check.should be_truthy
    end

    it 'creates day' do
      cafe_shift = build(:cafe_shift, lv: 1)
      cafe_shift.pass = nil
      cafe_shift.setup_mode = 'day'
      check = false

      lambda do
        check = CafeService.setup(cafe_shift)
      end.should change(CafeShift, :count).by(4)

      check.should be_truthy
    end
  end
end
