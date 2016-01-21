# encoding: UTF-8
module CafeService
  def self.setup(shift)
    if shift.lv.present? &&
       shift.lv_last.present? &&
       shift.start.present? &&
       shift.lp.present?
      begin
        CafeShift.create!(generate(first_w: shift.lv,
                                   last_w: shift.lv_last.to_i,
                                   start: shift.start,
                                   lp: shift.lp))
      rescue
        return false
      end
      true
    else
      false
    end
  end

  def self.generate(first_w:, last_w:, start:, lp:)
    shifts = []
    (first_w..last_w).each do |lv|
      (0..4).each do
        shifts << { start: start, lp: lp, pass: 1, lv: lv }
        shifts << { start: start, lp: lp, pass: 2, lv: lv }
        shifts << { start: start + 2.hours, lp: lp, pass: 3, lv: lv }
        shifts << { start: start + 2.hours, lp: lp, pass: 4, lv: lv }
        start += 1.days
      end
      start += 2.days
    end
    shifts
  end
end
