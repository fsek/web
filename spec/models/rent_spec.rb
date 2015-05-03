# encoding: UTF-8
require 'rails_helper'

RSpec.describe Rent, type: :model do
  subject(:rent) { build(:rent, user: create(:user, member_at: nil)) }
  let(:saved) { create(:rent, :good) }

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
      #TODO Must be fixed with new member thingy.
      context 'validate purpose when not a member' do
        it { should validate_presence_of(:purpose) }
      end
    end

    describe :Duration do
      context :when_no_council do
        it 'add error if duration is over 48' do
          rent = build(:rent, :over_48)
          rent.valid?
          rent.errors.get(:d_from).should include(', får inte vara längre än 48 h')
        end
        it 'do not add error if duration is under 48' do
          rent = build(:rent, :under_48)
          rent.valid?
          rent.errors.get(:d_from).should be_nil or not_include(', får inte vara längre än 48 h')
        end
        it 'valid when duration is under 48' do
          rent = build(:rent, :good, :under_48)
          rent.should be_valid
        end
      end
      context :when_council do
        it 'do not add error if duration is over 48' do
          rent = build(:rent, :over_48, :with_council)
          rent.valid?
          rent.errors.get(:d_from).should be_nil
        end
        it 'do not add error if duration is under 48' do
          rent = build(:rent, :under_48, :with_council)
          rent.valid?
          rent.errors.get(:d_from).should be_nil
        end
        it 'valid for any duration' do
          rent = build(:rent, :good, :over_48, :with_council)
          rent.should be_valid
        end
      end
    end

    describe :Dates_in_future do
      context :when_future do
        it 'add error if d_from > d_til' do
          rent.d_from = rent.d_til + 1.hour
          rent.valid?
          rent.errors.get(:d_til).should include('måste vara efter startdatumet.')
        end
        it 'do not add error if d_from < d_til ' do
          rent.valid?
          rent.errors.get(:d_til).should be_nil
        end
      end
      context :when_past do
        it 'add error if d_from > d_til' do
          rent.d_til = Time.zone.now - 10.hours
          rent.d_from = rent.d_til + 5.hours
          rent.valid?
          rent.errors.get(:d_til).should include("måste vara efter startdatumet.")
        end
        it 'add error if d_from > d_til' do
          rent.d_til = Time.zone.now - 10.hours
          rent.d_from = rent.d_til + 5.hours
          rent.valid?
          rent.errors.get(:d_from).should include("måste vara i framtiden.")
        end
        it 'add error if d_from < d_til' do
          rent.d_from = Time.zone.now - 10.hours
          rent.d_til = rent.d_from + 5.hours
          rent.valid?
          rent.errors.get(:d_from).should include("måste vara i framtiden.")
        end
      end
    end

    describe :Overlap do
      context :when_no_councils do
        let(:overlap) { create(:rent, :good) }
        let(:normal) { build(:rent, :good) }
        it 'invalid when d_til is within saved rent' do
          normal.d_from = overlap.d_from - 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
        end
        it 'invalid when d_from and d_til is within saved rent' do
          normal.d_from = overlap.d_from + 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
        end
        it 'add error if d_from is within saved' do
          normal.d_from = overlap.d_from + 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.valid?.should be_falsey
          normal.errors.get(:d_from).should include("överlappar med annan bokning")
        end
        it 'invalid when d_from is within saved rent' do
          normal.d_from = overlap.d_til - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.should_not be_valid
        end
        it 'do add error if d_from is within saved' do
          normal.d_from = overlap.d_til - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.valid?
          normal.errors.get(:d_from).should include("överlappar med annan bokning")
        end

        it 'valid when d_from and d_til is outside saved rent' do
          normal.d_from = overlap.d_til + 5.hours
          normal.d_til = normal.d_from + 5.hours
          normal.should be_valid
        end
        it 'do not add error if d_til and d_from is outside saved' do
          normal.d_from = overlap.d_til + 5.hours
          normal.d_til = normal.d_from + 5.hours
          normal.valid?
          normal.errors.get(:d_from).should be_nil
        end
      end

      context :when_first_council_second_not do
        let(:overlap) { create(:rent, :good, :with_council) }
        let(:normal) { build(:rent, :good) }
        it 'invalid when d_til is within' do
          normal.d_from = overlap.d_from - 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
          normal.errors.get(:d_from).should include('överlappar med annan bokning')
        end
        it 'invalid when d_from and d_til is within saved' do
          normal.d_from = overlap.d_from + 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
        end
        it 'invalid when d_from is within saved rent' do
          normal.d_from = overlap.d_til - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.should_not be_valid
        end
        it 'valid when d_from and d_til is outside saved rent' do
          normal.d_from = overlap.d_til + 5.hours
          normal.d_til = normal.d_from + 5.hours
          normal.should be_valid
        end
      end

      context :when_second_council_first_not do
        let(:overlap) { create(:rent, :good) }
        let(:normal) { build(:rent, :good, :with_council) }
        it 'valid when d_til is within good rent' do
          normal.d_from = overlap.d_from - 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should be_valid
        end
        it 'valid when d_from and d_til is within good rent' do
          normal.d_from = overlap.d_from + 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should be_valid
        end
        it 'valid when d_from is within good rent' do
          normal.d_from = overlap.d_til - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.should be_valid
        end
        it 'valid when d_from and d_til is outside good rent' do
          normal.d_from = overlap.d_til + 5.hours
          normal.d_til = normal.d_from + 5.hours
          normal.should be_valid
        end
      end

      context :when_two_councils do
        let(:overlap) { create(:rent, :good, :with_council) }
        let(:normal) { build(:rent, :good, :with_council) }
        it 'invalid when d_til is within good rent' do
          normal.d_from = overlap.d_from - 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
        end
        it 'do add error if d_til within saved' do
          normal.d_from = overlap.d_from - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.valid?
          normal.errors.get(:d_from).should include('överlappar med annan utskottsbokning')
        end
        it 'invalid when d_from and d_til is within good rent' do
          normal.d_from = overlap.d_from + 5.hours
          normal.d_til = overlap.d_til - 5.hours
          normal.should_not be_valid
        end
        it 'invalid when d_from is within good rent' do
          normal.d_from = overlap.d_til - 5.hours
          normal.d_til = overlap.d_til + 5.hours
          normal.should_not be_valid
        end
        it 'valid when d_from and d_til is outside good rent' do
          normal.d_from = overlap.d_til + 5.hours
          normal.d_til = normal.d_from + 5.hours
          normal.should be_valid
        end
      end
    end
    # This tests makes sure that dates are formatted into ISO8601 for
    # Fullcalendars json-feed
    # Ref.: https://github.com/fsek/web/issues/99
    # /d.wessman
    describe :Json do
      it 'check date format is iso8601' do
        (saved.as_json.to_json).should include(saved.d_from.iso8601.to_json)
        (saved.as_json.to_json).should include(saved.d_til.iso8601.to_json)
      end
    end
  end
end
