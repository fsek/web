# encoding: utf-8
module TimeHelper
  # Expecting two dates
  def date_range(from_date, until_date, options = {})
    options.symbolize_keys!
    format = options[:format] || :default

    if from_date.present? && until_date.present?
      from_date = from_date.to_date
      until_date = until_date.to_date

      if same_day?(from_date, until_date)
        I18n.l(from_date, format: format)
      elsif same_month?(from_date, until_date)
        %(#{I18n.l(from_date, format: :day)} - #{I18n.l(until_date, format: format)})
      elsif same_year?(from_date, until_date)
        %(#{I18n.l(from_date, format: :day_month)} - #{I18n.l(until_date, format: format)})
      else
        %(#{I18n.l(from_date, format: format)} - #{I18n.l(until_date, format: format)})
      end

    elsif from_date.present?
      I18n.l(from_date.to_date, format: format)
    elsif until_date.present?
      I18n.l(until_date.to_date, format: format)
    end
  end

  def time_range(from_time, until_time, options = {})
    options.symbolize_keys!
    format = options[:format] || :default

    if from_time.present? && until_time.present?
      if from_time == until_time
        I18n.l(from_time, format: format)
      elsif same_day?(from_time, until_time)
        %(#{I18n.l(from_time, format: :time)} - #{I18n.l(until_time, format: format)})
      else
        %(#{I18n.l(from_time, format: format)} - #{I18n.l(until_time, format: format)})
      end
    elsif from_time.present?
      I18n.l(from_time, format: format)
    elsif until_time.present?
      I18n.l(until_time, format: format)
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
