require 'rails_helper'

RSpec.describe CafeService do
  describe :setup do
    it :valid_setup do
      cafe_shift = build(:cafe_shift, lv: 1)
      cafe_shift.pass = nil
      cafe_shift.lv_last = 3
      check = false

      lambda do
        check = CafeService.setup(cafe_shift)
      end.should change(CafeShift, :count).by(60)

      check.should be_truthy
    end

    it :invalid_setup do
      invalid_cafe_shift = build(:cafe_shift, start: nil, lv: 1)
      invalid_cafe_shift.pass = nil
      invalid_cafe_shift.lv_last = 3
      check = true
      lambda do
        check = CafeService.setup(invalid_cafe_shift)
      end.should change(CafeShift, :count).by(0)

      check.should be_falsey
    end
  end
end
