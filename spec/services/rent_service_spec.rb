require 'rails_helper'

describe RentService do
  let(:user) { create(:user) }
  let(:council) { create(:council) }
  let(:other) { build(:user) }
  let(:rent) { build(:rent) }
  let(:admin) { build(:admin) }
  let(:overbook) { build(:rent) }
  let(:council_rent) { build(:rent, council: council) }
  let(:booked_council) { create(:rent, council: council, user: user) }

  describe :make_reservation do
    it :valid_reservation do
      RentService.reservation(user, rent).should be_truthy
    end

    it :invalid_reservation do
      rent.d_from = nil
      begin
        RentService.reservation(user, rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('activerecord.errors.messages.blank',
                                       attribute: Rent.human_attribute_name(:d_from)))
      end
    end
  end

  describe :overbook do
    before do
      other.save!
      overbook.save!
    end

    it :overbook do
      RentService.reservation(user, council_rent).should be_truthy
      overbook.reload
      overbook.aktiv.should be_falsey
    end

    it :not_overbook do
      begin
        RentService.reservation(user, rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('rent.validation.overlap'))
      end
    end

    it :not_overbook do
      booked_council.reload
      begin
        RentService.reservation(user, council_rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('rent.validation.overlap_council'))
      end
    end
  end

  describe :authorized_update do
    before do
      rent.user = user
      rent.save!
      other.save!
    end

    it :valid_update do
      RentService.update({ purpose: 'A test' }, user, rent).should be_truthy
      Rent.first.purpose.should eq('A test')
    end

    it :invalid_update do
      rent.owner?(other).should be_falsey
      RentService.update({ purpose: 'A test' }, other, rent).should be_falsey
    end
  end

  describe :admin_reservation do
  end

  describe :administrate do
  end
end
