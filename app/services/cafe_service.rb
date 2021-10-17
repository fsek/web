module CafeService
  def self.setup(shift)
    if shift.setup_mode == "week"
      setup_week(shift)
    elsif shift.setup_mode == "day"
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
      5.times do
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
    shifts << {start: start, lp: lp, pass: 1, lv: lv}
    shifts << {start: start, lp: lp, pass: 1, lv: lv}
    shifts << {start: start + 2.hours, lp: lp, pass: 2, lv: lv}
    shifts << {start: start + 2.hours, lp: lp, pass: 2, lv: lv}
    shifts
  end

  def self.group_cafe_shifts(date_start, date_end, shifts)
    hash = Hash.new { |h|
      h[:years] = Hash.new { |h2, m|
        h2[m] = Hash.new { |h3|
          h3[:months] = Hash.new { |h4, a|
            h4[a] = Hash.new { |h5|
              h5[:days] = {}
            }
          }
        }
      }
    }

    date = Time.parse(date_start)
    end_day = Time.parse(date_end)
    while date <= end_day
      unless date.on_weekend?
        hash[:years][date.year][:months][I18n.t("date.month_names")[date.month].capitalize][:days]["#{I18n.t("date.day_names")[date.wday].capitalize} - #{date.day}/#{date.month}"] = []
      end
      date += 1.day
    end

    shifts.each_with_object(hash) do |shift, h|
      week_day = shift.start.wday # Returns the day of week (0-6, Sunday is zero)
      month = shift.start.month
      day_name = I18n.t("date.day_names")[week_day].capitalize
      month_name = I18n.t("date.month_names")[month].capitalize
      h[:years][shift.start.year][:months][month_name][:days]["#{day_name} - #{shift.start.day}/#{shift.start.month}"]&.push(Api::CafeShiftSerializer::Index.new(shift).as_json)
    end
  end
end
