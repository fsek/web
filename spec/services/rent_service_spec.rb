require 'rails_helper'

RSpec.describe RentService do
  describe :make_reservation do
    it :valid_reservation do
      user = create(:user)
      rent = build(:rent, user: user)

      lambda do
        RentService.reservation(user, rent, true).should be_truthy
      end.should change(Rent, :count).by(1)
    end

    it :invalid_reservation do
      user = create(:user)
      rent = build(:rent, user: nil, d_from: nil)

      lambda do
        RentService.reservation(user, rent, true).should be_falsey
      end.should change(Rent, :count).by(0)
    end
  end

  describe :overbook do
    it 'should let council overbook normal' do
      user = create(:user)
      overbook = create(:rent, user: user)
      council_rent = build(:rent, :with_council, user: user)

      lambda do
        RentService.reservation(user, council_rent, true).should be_truthy
      end.should change(Rent, :count).by(1)

      overbook.reload
      overbook.aktiv.should be_falsey
    end

    it 'should not let normal overbook council' do
      user = create(:user)
      overbook = create(:rent, user: user)
      rent = build(:rent, user: user)

      lambda do
        RentService.reservation(user, rent, true).should be_falsey
      end.should change(Rent, :count).by(0)

      overbook.reload
      overbook.aktiv.should be_truthy
    end

    it 'should not let council overbook council' do
      user = create(:user)
      overbook = create(:rent, :with_council, user: user)
      council_rent = build(:rent, :with_council, user: user)

      lambda do
        RentService.reservation(user, council_rent, true).should be_falsey
      end.should change(Rent, :count).by(0)

      overbook.reload
      overbook.aktiv.should be_truthy
    end
  end

  describe :authorized_update do
    it 'valid parameters' do
      user = create(:user)
      rent = create(:rent, user: user, purpose: 'Nope')

      RentService.update({ purpose: 'A test' }, user, rent).should be_truthy

      rent.reload
      rent.purpose.should eq('A test')
    end

    it 'invalid parameters' do
      user = create(:user)
      rent = create(:rent, purpose: 'Nope')

      rent.owner?(user).should be_falsey

      RentService.update({ purpose: 'A test' }, user, rent).should be_falsey
      Rent.first.purpose.should eq('Nope')
    end
  end

  describe :admin_reservation do
    it 'valid parameters' do
      rent = build(:rent)

      lambda do
        RentService.admin_reservation(rent).should be_truthy
      end.should change(Rent, :count).by(1)
    end

    it 'invalid parameters' do
      rent = build(:rent, user: nil)

      lambda do
        RentService.admin_reservation(rent).should be_falsey
      end.should change(Rent, :count).by(0)
    end
  end

  describe :administrate do
    it 'valid parameters' do
      rent = create(:rent, purpose: 'Nope')
      RentService.administrate(rent, purpose: 'A test').should be_truthy
      Rent.first.purpose.should eq('A test')
    end

    it 'invalid parameters' do
      rent = create(:rent)
      RentService.administrate(rent, user: nil).should be_falsey
    end
  end
end
