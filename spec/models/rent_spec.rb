# encoding: UTF-8
require 'rails_helper'

RSpec.describe Rent, type: :model do
  let(:member) { create(:user) }
  let(:n_member) { create(:user, :not_member) }

  let(:council) { create(:council) }

  let(:new_rent) { build(:rent, user: member) }
  let(:new_rent_council) { build(:rent, user: member, council: council) }
  subject(:rent_n) { build(:rent, user: n_member) }

  let(:rent) do
    create(:rent, user: member, d_from: Time.zone.now + 15.days,
                  d_til: Time.zone.now + 15.days + 12.hours)
  end
  let(:rent_council) do
    create(:rent, user: member, council: council, d_from: Time.zone.now + 20.days,
                  d_til: Time.zone.now + 20.days + 12.hours)
  end

  describe 'has valid factory' do
    it { should be_valid }
  end

  describe :associations do
    it { should belong_to(:user) }
    it { should belong_to(:council) }
  end

  describe :validations do
    it { should validate_presence_of(:d_from) }
    it { should validate_presence_of(:d_til) }

    describe :duration do
      context :when_no_council do
        it 'add error if duration is over 48' do
          rent = build(:rent, :over_48)
          rent.valid?

          rent.should_not be_valid
          rent.errors.get(:d_from).should include(I18n.t('rent.validation.duration'))
        end

        it 'do not add error if duration is under 48' do
          rent = build(:rent, :under_48)
          rent.should be_valid
        end
      end

      context :when_council do
        it 'do not add error if duration is over 48' do
          rent = build(:rent, :over_48, :with_council)
          rent.should be_valid
        end
      end
    end

    describe :dates_in_future do
      context :when_future do
        it 'add error if d_from > d_til' do
          new_rent.d_from = new_rent.d_til + 1.hour
          new_rent.should_not be_valid
          new_rent.errors.get(:d_til).should include(I18n.t('rent.validation.ascending'))
        end
      end
      context :when_past do
        it 'add error if d_from > d_til' do
          new_rent.d_til = Time.zone.now - 10.hours
          new_rent.d_from = new_rent.d_til + 5.hours
          new_rent.should_not be_valid
          new_rent.errors.get(:d_from).should include(I18n.t('rent.validation.future'))
        end

        it 'add error if d_from < d_til' do
          new_rent.d_from = Time.zone.now - 10.hours
          new_rent.d_til = new_rent.d_from + 5.hours
          new_rent.should_not be_valid
          new_rent.errors.get(:d_from).should include(I18n.t('rent.validation.future'))
        end
      end
    end

    # Validate if overlap
    describe :overlap do
      # The times mark offset from:
      # new.from = saved.from + offset
      # new.from = saved.til + offset
      # new.til = saved.from + offset
      # new.til = saved.til + offset
      overlap = {
        end: [-5, 0, 0, -5],
        from: [5, 0, 0, 5],
        both: [5, 0, 0, -5],
        none: [-5, 0, 0, 5],
        after: [0, 5, 0, 5]
      }

      context 'no councils' do
        b = { end: false, from: false, both: false, none: false, after: true }
        overlap.each do |key, value|
          it %(#{key} should be #{b[key]}) do
            new_rent.d_from = rent.d_from + value[0] unless value[0] == 0
            new_rent.d_from = rent.d_til + value[1] unless value[1] == 0
            new_rent.d_til = rent.d_from + value[2] unless value[2] == 0
            new_rent.d_til = rent.d_til + value[3] unless value[3] == 0

            new_rent.valid?.should eq(b[key])
          end
        end
      end

      context 'new council' do
        overlap.each do |key, value|
          it %(#{key} should be true) do
            new_rent_council.d_from = rent.d_from + value[0] unless value[0] == 0
            new_rent_council.d_from = rent.d_til + value[1] unless value[1] == 0
            new_rent_council.d_til = rent.d_from + value[2] unless value[2] == 0
            new_rent_council.d_til = rent.d_til + value[3] unless value[3] == 0

            new_rent_council.valid?.should eq(true)
          end
        end
      end

      context 'saved council' do
        b = { end: false, from: false, both: false, none: false, after: true }
        overlap.each do |key, value|
          it %(#{key} should be #{b[key]}) do
            new_rent.d_from = rent_council.d_from + value[0] unless value[0] == 0
            new_rent.d_from = rent_council.d_til + value[1] unless value[1] == 0
            new_rent.d_til = rent_council.d_from + value[2] unless value[2] == 0
            new_rent.d_til = rent_council.d_til + value[3] unless value[3] == 0

            new_rent.valid?.should eq(b[key])
          end
        end
      end

      context 'both council' do
        b = { end: false, from: false, both: false, none: false, after: true }
        overlap.each do |key, value|
          it %(#{key} should be #{b[key]}) do
            new_rent_council.d_from = rent_council.d_from + value[0] unless value[0] == 0
            new_rent_council.d_from = rent_council.d_til + value[1] unless value[1] == 0
            new_rent_council.d_til = rent_council.d_from + value[2] unless value[2] == 0
            new_rent_council.d_til = rent_council.d_til + value[3] unless value[3] == 0

            new_rent_council.valid?.should eq(b[key])
          end
        end
      end
    end

    # This tests makes sure that dates are formatted into ISO8601 for
    # Fullcalendars json-feed
    # Ref.: https://github.com/fsek/web/issues/99
    describe :Json do
      it 'check date format is iso8601' do
        (rent.as_json.to_json).should include(rent.d_from.iso8601.to_json)
        (rent.as_json.to_json).should include(rent.d_til.iso8601.to_json)
      end
    end
  end
end
