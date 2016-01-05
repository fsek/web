require 'rails_helper'

RSpec.describe TimeHelper do
  describe 'date_range' do
    context 'same day' do
      from_date = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 8.hours
      it 'print only one date' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date)}))
      end

      it 'print only one date, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: :short)}))
      end
    end

    context 'same month' do
      from_date = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 4.days + 8.hours
      it 'day span with month and year' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date, format: :day)} - #{I18n.l(until_date.to_date)}))
      end

      it 'day span with month and year, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: :day)} - #{I18n.l(until_date.to_date, format: :short)}))
      end
    end

    context 'same year' do
      from_date = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 14.days + 8.hours
      it 'print with same year' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date, format: :day_month)} - #{I18n.l(until_date.to_date)}))
      end

      it 'print with same year, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: :day_month)} - #{I18n.l(until_date.to_date, format: :short)}))
      end
    end

    context 'missing variable' do
      from_date = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 8.hours
      it 'print first date' do
        helper.date_range(from_date, nil).should \
          eq(I18n.l(from_date.to_date))
      end

      it 'print second date' do
        helper.date_range(from_date, nil).should \
          eq(I18n.l(until_date.to_date))
      end

      it 'print first date, short' do
        helper.date_range(from_date, nil, format: :short).should \
          eq(I18n.l(from_date.to_date, format: :short))
      end

      it 'print second date, short' do
        helper.date_range(nil, until_date, format: :short).should \
          eq(I18n.l(until_date.to_date, format: :short))
      end
    end
  end

  describe 'time range' do
    context 'same day' do
      from_time = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_time = from_time + 8.hours
      it 'print both times followed by one date' do
        helper.time_range(from_time, until_time).should \
          eq(%(#{I18n.l(from_time, format: :time)} - #{I18n.l(until_time)}))
      end

      it 'print both times followed by one date, short' do
        helper.time_range(from_time, until_time, format: :short).should \
          eq(%(#{I18n.l(from_time, format: :time)} - #{I18n.l(until_time, format: :short)}))
      end
    end

    context 'not same day' do
      from_time = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_time = from_time + 4.days + 8.hours
      it 'time range' do
        helper.time_range(from_time, until_time).should \
          eq(%(#{I18n.l(from_time)} - #{I18n.l(until_time)}))
      end

      it 'time range, short' do
        helper.time_range(from_time, until_time, format: :short).should \
          eq(%(#{I18n.l(from_time, format: :short)} - #{I18n.l(until_time, format: :short)}))
      end
    end

    context 'missing variable' do
      from_time = Time.zone.local(Time.zone.now.year, 3, 25, 12)
      until_time = from_time + 8.hours
      it 'print first date' do
        helper.time_range(from_time, nil).should \
          eq(I18n.l(from_time))
      end

      it 'print second date' do
        helper.time_range(from_time, nil).should \
          eq(I18n.l(from_time))
      end

      it 'print first date, short' do
        helper.time_range(from_time, nil, format: :short).should \
          eq(I18n.l(from_time, format: :short))
      end

      it 'print second time, short' do
        helper.time_range(nil, until_time, format: :short).should \
          eq(I18n.l(until_time, format: :short))
      end
    end
  end
end
