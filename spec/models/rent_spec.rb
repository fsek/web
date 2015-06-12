# encoding: UTF-8
require 'rails_helper'

RSpec.describe Rent, type: :model do
  let(:member) { create(:user, member_at: Time.zone.now) }
  let(:n_member) { create(:user, member_at: nil) }

  let(:council) { create(:council) }

  let(:new_rent) { build(:rent, user: member) }
  let(:new_rent_council) { build(:rent, user: member, council: council) }
  subject(:rent_n) { build(:rent, user: n_member) }

  let(:rent) { create(:rent, user: member, d_from: Time.zone.now + 15.days,
                      d_til: Time.zone.now + 15.days + 12.hours) }
  let(:rent_council) { create(:rent, user: member, council: council, d_from: Time.zone.now + 20.days, d_til: Time.zone.now + 20.days + 12.hours) }

  describe 'has valid factory' do
    it { should be_valid }
  end

  describe :Associations do
    it { should belong_to(:user) }
    it { should belong_to(:council) }
  end

  describe :Validations do
    it { should allow_value(true).for(:disclaimer) }
    it { should_not allow_value(false).for(:disclaimer) }

    describe :RequiredAttributes do
      it { should validate_presence_of(:d_from) }
      it { should validate_presence_of(:d_til) }
      it { should validate_presence_of(:user) }
    end

    describe :Purpose do
      context 'validate purpose when not a member' do
        it { rent_n.should validate_presence_of(:purpose) }
        it { rent.should_not validate_presence_of(:purpose) }
      end
    end

    describe :Duration do
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

    describe :Dates_in_future do
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

    describe :Overlap do
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

    describe 'overbook' do
      it 'overbooks when ok' do
        new_rent_council.d_from = rent.d_from - 5.hours
        new_rent_council.d_til = rent.d_from + 1.hours
        Rails.logger.info rent.d_from.to_s
        Rails.logger.info rent.d_til.to_s
        Rails.logger.info new_rent_council.d_from.to_s
        Rails.logger.info new_rent_council.d_til.to_s
        Rails.logger.info '\n\n\n\n\n'

        new_rent_council.should be_valid
        rent.should be_valid
        new_rent_council.save!
        rent.aktiv.should be_falsey
      end
    end

    # This tests makes sure that dates are formatted into ISO8601 for
    # Fullcalendars json-feed
    # Ref.: https://github.com/fsek/web/issues/99
    # /d.wessman
    describe :Json do
      it 'check date format is iso8601' do
        (rent.as_json.to_json).should include(rent.d_from.iso8601.to_json)
        (rent.as_json.to_json).should include(rent.d_til.iso8601.to_json)
      end
    end
  end
end
