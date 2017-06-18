require 'rails_helper'

RSpec.describe Rent, type: :model do
  describe :associations do
    it { Rent.new.should belong_to(:user) }
    it { Rent.new.should belong_to(:council) }
  end

  describe :validations do
    it { Rent.new.should validate_presence_of(:d_from) }
    it { Rent.new.should validate_presence_of(:d_til) }

    describe :duration do
      context :when_no_council do
        it 'add error if duration is over 48' do
          rent = build_stubbed(:rent, :over_48)

          rent.should_not be_valid
          rent.errors[:d_from].should include(I18n.t('model.rent.validation.duration'))
        end

        it 'do not add error if duration is under 48' do
          rent = build_stubbed(:rent, :under_48)
          rent.should be_valid
        end
      end

      context :when_council do
        it 'do not add error if duration is over 48' do
          rent = build_stubbed(:rent, :over_48, :with_council)
          rent.should be_valid
        end
      end
    end

    describe :dates_in_future do
      context :when_future do
        it 'add error if d_from > d_til' do
          rent = build_stubbed(:rent, d_from: 5.hours.from_now, d_til: 4.hours.from_now)

          rent.should_not be_valid
          rent.errors[:d_til].should include(I18n.t('model.rent.validation.ascending'))
        end
      end

      context :when_past do
        it 'add error if d_from > d_til' do
          rent = build_stubbed(:rent, d_from: 5.hours.ago, d_til: 10.hours.ago, id: nil)

          rent.should_not be_valid
          rent.errors[:d_from].should include(I18n.t('model.rent.validation.future'))
        end

        it 'add error if d_from < d_til' do
          rent = build_stubbed(:rent, d_from: 10.hours.ago, d_til: 5.hours.ago, id: nil)

          rent.should_not be_valid
          rent.errors[:d_from].should include(I18n.t('model.rent.validation.future'))
        end
      end
    end

    # Validate if overlap
    describe :overlap do
      context 'no councils' do
        it 'overlaps with d_til' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til + 5.hours)

          new_rent.should_not be_valid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap'))
        end

        it 'overlaps with d_from' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_from - 5.hours,
                                   d_til: rent.d_from + 5.hours)

          new_rent.should_not be_valid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap'))
        end

        it 'overlaps with both d_from and d_til' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_from - 5.hours,
                                   d_til: rent.d_til + 5.hours)

          new_rent.should_not be_valid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap'))
        end

        it 'overlaps between d_from and d_til' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til - 5.hours)

          new_rent.should_not be_valid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap'))
        end

        it 'does not overlap' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_til + 5.hours,
                                   d_til: rent.d_til + 10.hours)

          new_rent.should be_valid
          new_rent.errors[:d_from].should be_empty
        end
      end

      context 'new council booking' do
        it 'allows to overlap non council' do
          rent = create(:rent, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent, :with_council,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til - 5.hours)
          new_rent.should be_valid
        end

        it 'does not allow to overbook if < 5 days away' do
          rent = create(:rent, d_from: 3.days.from_now, d_til: 4.days.from_now)
          new_rent = build_stubbed(:rent, :with_council,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til - 5.hours)
          new_rent.should be_invalid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap_overbook'))
        end
      end

      context 'saved council' do
        it 'does not allow non council booking to overlap' do
          rent = create(:rent, :with_council, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til - 5.hours)
          new_rent.should be_invalid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap'))
        end

        it 'does not allow new council booking to overlap' do
          rent = create(:rent, :with_council, d_from: 10.days.from_now, d_til: 11.days.from_now)
          new_rent = build_stubbed(:rent, :with_council,
                                   d_from: rent.d_from + 5.hours,
                                   d_til: rent.d_til - 5.hours)
          new_rent.should be_invalid
          new_rent.errors[:d_from].should include(I18n.t('model.rent.validation.overlap_council'))
        end
      end
    end

    # This tests makes sure that dates are formatted into ISO8601 for
    # Fullcalendars json-feed
    # Ref.: https://github.com/fsek/web/issues/99
    describe :Json do
      it 'check date format is iso8601' do
        rent = build_stubbed(:rent)
        (rent.as_json.to_json).should include(rent.d_from.iso8601.to_json)
        (rent.as_json.to_json).should include(rent.d_til.iso8601.to_json)
      end
    end
  end
end
