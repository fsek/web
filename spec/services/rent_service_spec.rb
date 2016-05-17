require 'rails_helper'

RSpec.describe RentService do
  describe :make_reservation do
    it :valid_reservation do
      user = create(:user)
      rent = build(:rent, user: user)

      RentService.reservation(user, rent).should be_truthy
    end

    it :invalid_reservation do
      user = create(:user)
      rent = build(:rent, user: nil, d_from: nil)

      begin
        RentService.reservation(user, rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('activerecord.errors.messages.blank',
                                       attribute: Rent.human_attribute_name(:d_from)))
      end
    end
  end

  describe :overbook do
    it :overbook do
      user = create(:user)
      overbook = create(:rent, user: user)
      council_rent = build(:rent, :with_council, user: user)

      RentService.reservation(user, council_rent).should be_truthy

      overbook.reload
      overbook.aktiv.should be_falsey
    end

    it :not_overbook do
      user = create(:user)
      overbook = create(:rent, user: user)
      rent = build(:rent, user: user)

      begin
        RentService.reservation(user, rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('model.rent.validation.overlap'))
      end

      overbook.reload
      overbook.aktiv.should be_truthy
    end

    it :not_overbook do
      user = create(:user)
      overbook = create(:rent, :with_council, user: user)
      council_rent = build(:rent, :with_council, user: user)

      begin
        RentService.reservation(user, council_rent)
      rescue ActiveRecord::RecordInvalid => error
        error.message.should include(t('model.rent.validation.overlap_council'))
      end

      overbook.reload
      overbook.aktiv.should be_truthy
    end
  end

  describe :authorized_update do
    it :valid_update do
      user = create(:user)
      rent = create(:rent, user: user, purpose: 'Nope')

      RentService.update({ purpose: 'A test' }, user, rent).should be_truthy
      Rent.first.purpose.should eq('A test')
    end

    it :invalid_update do
      user = create(:user)
      rent = create(:rent, purpose: 'Nope')

      rent.owner?(user).should be_falsey
      RentService.update({ purpose: 'A test' }, user, rent).should be_falsey
      Rent.first.purpose.should eq('Nope')
    end
  end

  describe :admin_reservation do
    it :valid_reservation do
      rent = build(:rent)

      lambda do
        RentService.admin_reservation(rent).should be_truthy
      end.should change(Rent, :count).by(1)
    end

    it :invalid_reservation do
      rent = build(:rent, user: nil)

      RentService.admin_reservation(rent).should be_falsey
    end
  end

  describe :administrate do
    it :valid_update do
      rent = create(:rent, purpose: 'Nope')
      RentService.administrate(rent, purpose: 'A test').should be_truthy
      Rent.first.purpose.should eq('A test')
    end

    it :invalid_update do
      rent = create(:rent)
      RentService.administrate(rent, user: nil).should be_falsey
    end
  end
end
