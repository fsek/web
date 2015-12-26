# encoding: UTF-8
module CafeService
  def self.setup(start, stop, day, lp)
    CafeShift.create!(preview(start, stop, day, lp))
  end

  def self.preview(start, stop, day, lp)
    shifts = []
    (start..stop).each do |lv|
      (0..4).each do
        shifts << { start: day, lp: lp, pass: 1, lv: lv }
        shifts << { start: day, lp: lp, pass: 2, lv: lv }
        shifts << { start: day + 2.hours, lp: lp, pass: 3, lv: lv }
        shifts << { start: day + 2.hours, lp: lp, pass: 4, lv: lv }
        day += 1.days
      end
      day += 2.days
    end
    shifts
  end
end
