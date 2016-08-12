# encoding: utf-8
module TimeHelper
  # Expecting two dates
  def date_range(from_date, until_date, format: :default)
    if from_date.present? && until_date.present?
      from_date = from_date.to_date
      until_date = until_date.to_date

      if same_day?(from_date, until_date)
        I18n.l(from_date, format: format)
      elsif same_month?(from_date, until_date)
        print_dates(from_date, :day, until_date, format)
      elsif same_year?(from_date, until_date)
        print_dates(from_date, :day_month, until_date, format)
      else
        print_dates(from_date, format, until_date, format)
      end

    elsif from_date.present?
      I18n.l(from_date.to_date, format: format)
    elsif until_date.present?
      I18n.l(until_date.to_date, format: format)
    end
  end

  def time_range(from_time, until_time, format: :default, dot: nil)
    if from_time.present? && until_time.present?
      if from_time == until_time
        I18n.l(from_time, format: format)
      elsif same_day?(from_time, until_time)
        print_dates(from_time, :time, until_time, format, dot: dot)
      else
        print_dates(from_time, format, until_time, format, dot: dot)
      end
    elsif from_time.present?
      I18n.l(from_time, format: format)
    elsif until_time.present?
      I18n.l(until_time, format: format)
    end
  end

  def print_dates(from, from_format, til, til_format, dot: nil)
    %(#{I18n.l(from, format: dot_format(from_format, dot: dot))} - #{I18n.l(til, format: til_format)})
  end

  def dot_format(format, dot: nil)
    dot = dot.to_s.to_sym
    if dot == :single
      "#{format}_dot".to_sym
    elsif dot == :double
      "#{format}_ddot".to_sym
    elsif dot == :without
      "#{format}_without".to_sym
    else
      format
    end
  end

  def localized(date, options = {})
    if date.present?
      I18n.l(date, options)
    else
      fa_icon('cogs')
    end
  end

  private

  def same_day?(first, second)
    first.day == second.day && same_month?(first, second)
  end

  def same_month?(first, second)
    first.month == second.month && same_year?(first, second)
  end

  def same_year?(first, second)
    first.year == second.year
  end
end
