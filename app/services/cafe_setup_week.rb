#encoding: UTF-8
class CafeSetupWeek
  def initialize(day, lp)
    @day = day
    @lp = lp
  end

  def setup(start, stop)
    preview(start,stop).each do |cwork|
      cwork.save
    end
  end

  def preview(start, stop)
    @cworks =  []
    (start..stop).each do |lv|
      (0..4).each do
        @cworks << CafeWork.new(work_day: @day, lp: @lp, pass: 1, lv: lv, d_year: @day.year)
        @cworks << CafeWork.new(work_day: @day, lp: @lp, pass: 2, lv: lv, d_year: @day.year)
        @cworks << CafeWork.new(work_day: @day + 2.hours, lp: @lp, pass: 3, lv: lv, d_year: @day.year)
        @cworks << CafeWork.new(work_day: @day + 2.hours, lp: @lp, pass: 4, lv: lv, d_year: @day.year)
        @day = @day + 1.days
      end
      @day = @day + 2.days
    end
    @cworks
  end
end
