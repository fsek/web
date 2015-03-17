#encoding: UTF-8
require 'rails_helper'

RSpec.describe CafeWork, type: :model do
  subject(:cafe_work) { FactoryGirl.build(:cafe_work) }
  subject(:saved) { FactoryGirl.create(:cafe_work) }


  it "has a valid factory" do
    # Using the shortened version of FactoryGirl syntax.
    # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:cafe_work)).to be_valid
  end

  describe :Associations do
    it { should belong_to(:profile) }
    # Should validate has_and_belongs_to_many
  end

  describe :Validations do
    describe :RequiredAttributes do
      it { should validate_presence_of(:work_day) }
      it { should validate_presence_of(:pass) }
      it { should validate_presence_of(:lp) }
      it { should validate_presence_of(:lv) }
      it { should validate_uniqueness_of(:pass).scoped_to(:work_day, :lv, :lp, :d_year) }
      context "if has_worker on update" do
        before { allow(saved).to receive(:has_worker?).and_return(true) }
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:lastname) }
        it { should validate_presence_of(:phone) }
        it { should validate_presence_of(:email) }
      end
    end
  end

  describe :Worker do
    subject(:user) { FactoryGirl.create(:user) }
    it 'do not have worker if profile and access_code is nil' do
      r = saved
      r.clear_worker
      expect(r.has_worker?).to be_falsey
    end
    it 'do have worker if profile is not nil' do
      r = FactoryGirl.create(:cafe_work, :with_profile)
      expect(r.has_worker?).to be_truthy
    end
    it 'do have worker if access_code is not nil' do
      r = FactoryGirl.create(:cafe_work, :with_access_code)
      expect(r.has_worker?).to be_truthy
    end
    it 'add worker with params and no user' do
      r = FactoryGirl.create(:cafe_work)
      r.add_worker(FactoryGirl.attributes_for(:cafe_work), nil)
      expect(r.has_worker?).to be_truthy
    end
    it 'add worker with params and no user, has access_code' do
      r = FactoryGirl.create(:cafe_work)
      r.add_worker(FactoryGirl.attributes_for(:cafe_work), nil)
      expect(r.access_code).to_not be_nil
    end
    it 'add worker with params and with user' do
      r = FactoryGirl.create(:cafe_work)
      r.add_worker(FactoryGirl.attributes_for(:cafe_work), user)
      expect(r.has_worker?).to be_truthy
    end
    it 'add worker with params and user, have profile' do
      r = FactoryGirl.create(:cafe_work)
      r.add_worker(FactoryGirl.attributes_for(:cafe_work), user)
      expect(r.profile).to_not be_nil
    end
    it 'update worker with user' do
      r = FactoryGirl.create(:cafe_work)
      r.update_worker(FactoryGirl.attributes_for(:cafe_work,:test_work), r.profile.user)
      expect(r.name).to eq("Test")
    end

  end

end
