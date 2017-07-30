require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    (build_stubbed(:user)).should be_valid
  end

  let(:user) { build_stubbed(:user) }

  describe 'validations' do
    new_user = User.new
    it { new_user.should validate_presence_of(:email) }
    it { new_user.should validate_presence_of(:firstname) }
    it { new_user.should validate_presence_of(:lastname) }
  end

  describe 'name validation' do
    it 'accepts names with at least two characters' do
      user.lastname = 'Pi'
      user.should be_valid
    end

    it 'does not accept names with less than 2 characters' do
      user.lastname = 'F'
      user.should be_invalid
    end

    it 'accepts unicode names with accents' do
      user.lastname = 'Ναβροζίδης'
      user.should be_valid
    end

    it 'accepts spaces and hyphens' do
      user.lastname = 'Älg-Älg Älg'
      user.should be_valid
    end

    it 'does not accept numbers' do
      user.lastname = 'Nisse37'
      user.should be_invalid
    end

    it 'does not accept special characters' do
      user.lastname = 'Ka$$ör'
      user.should be_invalid
    end
  end

  describe 'public instance methods' do
    context 'printing' do
      it 'print_id' do
        user.print_id.should eq(%(#{user.firstname} #{user.lastname} - #{user.id}))
      end

      it 'print_email' do
        user.print_email.should eq(%(#{user.firstname} #{user.lastname} <#{user.email}>))
      end

      it 'to_s' do
        user.to_s.should eq(%(#{user.firstname} #{user.lastname}))
      end

      it 'program_year' do
        user = User.new(program: User::PHYSICS, start_year: 1996)
        user.program_year.should eq('F96')
      end

      it 'print_program' do
        user = User.new(program: User::PHYSICS, start_year: 1996,
                        firstname: 'Hilbert', lastname: 'Älg')
        user.print_program.should eq('Hilbert Älg - F96')
      end
    end

    it 'checks if summerchild' do
      user = build_stubbed(:user, member_at: User.summer + 10.days)
      user.summerchild?.should be_truthy

      user.member_at = User.summer - 10.days
      user.summerchild?.should be_falsey
    end
  end
end
