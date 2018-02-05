# encoding: UTF-8
module CafeService
  def self.setup(shift)
    if shift.setup_mode == 'week'
      setup_week(shift)
    elsif shift.setup_mode == 'day'
      setup_day(shift)
    else
      false
    end
  end

  def self.setup_week(shift)
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

  def self.setup_day(shift)
    if shift.lv.present? &&
       shift.start.present? &&
       shift.lp.present?
      begin
        CafeShift.create!(generate_day(start: shift.start,
                                       lp: shift.lp,
                                       lv: shift.lv))
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
        shifts += generate_day(start: start,
                               lp: lp,
                               lv: lv)
        start += 1.days
      end
      start += 2.days
    end
    shifts
  end

  def self.generate_day(start:, lp:, lv:)
    shifts = []
    shifts << { start: start, lp: lp, pass: 1, lv: lv }
    shifts << { start: start, lp: lp, pass: 1, lv: lv }
    shifts << { start: start + 2.hours, lp: lp, pass: 2, lv: lv }
    shifts << { start: start + 2.hours, lp: lp, pass: 2, lv: lv }
    shifts
  end
end
