require 'rails_helper'

describe TimeHelper do
  describe 'date_range' do
    context 'same day' do
      from_date = Time.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 8.hours
      it 'print only one date' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date, format: :long)}))
      end

      it 'print only one date, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: :short)}))
      end
    end

    context 'same month' do
      from_date = Time.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 4.days + 8.hours
      it 'day span with month and year' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date, format: '%-d')} - #{I18n.l(until_date.to_date, format: :long)}))
      end

      it 'day span with month and year, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: '%-d')} - #{I18n.l(until_date.to_date, format: :short)}))
      end
    end

    context 'same year' do
      from_date = Time.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 14.days + 8.hours
      it 'print with same year' do
        helper.date_range(from_date, until_date).should \
          eq(%(#{I18n.l(from_date.to_date, format: '%-d %B')} - #{I18n.l(until_date.to_date, format: :long)}))
      end

      it 'print wiht same year, short' do
        helper.date_range(from_date, until_date, format: :short).should \
          eq(%(#{I18n.l(from_date.to_date, format: '%-d %B')} - #{I18n.l(until_date.to_date, format: :short)}))
      end
    end

    context 'missing variable' do
      from_date = Time.local(Time.zone.now.year, 3, 25, 12)
      until_date = from_date + 8.hours
      it 'print first date' do
        helper.date_range(from_date, nil).should \
          eq(I18n.l(from_date.to_date, format: :long))
      end

      it 'print second date' do
        helper.date_range(from_date, nil).should \
          eq(I18n.l(until_date.to_date, format: :long))
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
end
