require 'rails_helper'

RSpec.describe CafeWork, type: :model do
  it "has a valid factory" do
    expect(build(:cafe_work)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:cwork_profile) { create(:cafe_work,:w_profile)}
  let(:cwork_access) { create(:cafe_work,:access)}
  let(:cwork) { build(:cafe_work) }
  let(:cwork_no_worker) { create(:cafe_work) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(cwork).to validate_presence_of(:work_day) }
    it { expect(cwork).to validate_presence_of(:pass) }
    it { expect(cwork).to validate_presence_of(:lp) }
    it { expect(cwork).to validate_presence_of(:lv) }

    context 'if has_worker' do
      it { expect(cwork_profile).to validate_presence_of(:name) }
      it { expect(cwork_profile).to validate_presence_of(:lastname) }
      it { expect(cwork_access).to validate_presence_of(:phone) }
      it { expect(cwork_access).to validate_presence_of(:email) }
    end

  end

  describe "ActiveRecord associations" do
    # Associations
    it { expect(cwork).to belong_to(:profile) }
    it { expect(cwork).to have_and_belong_to_many(:councils) }

  end

  context "callbacks" do
    describe "public instance methods" do
      context "responds to its methods" do
        it { expect(cwork_profile).to respond_to(:send_email) }
        it { expect(cwork_profile).to respond_to(:load) }
        it { expect(cwork_profile).to respond_to(:status_text) }
        it { expect(cwork_profile).to respond_to(:status_view) }
        it { expect(cwork_profile).to respond_to(:add_or_update) }
        it { expect(cwork_profile).to respond_to(:add_worker) }
        it { expect(cwork_profile).to respond_to(:update_worker) }
        it { expect(cwork_profile).to respond_to(:remove_worker) }
        it { expect(cwork_profile).to respond_to(:clear_worker) }
        it { expect(cwork_profile).to respond_to(:owner?) }
        it { expect(cwork_profile).to respond_to(:edit?) }
        it { expect(cwork_profile).to respond_to(:authorize) }
        it { expect(cwork_profile).to respond_to(:has_worker?) }
        it { expect(cwork_profile).to respond_to(:print_time) }
        it { expect(cwork_profile).to respond_to(:print) }
        it { expect(cwork_profile).to respond_to(:print_date) }
        it { expect(cwork_profile).to respond_to(:p_url) }
        it { expect(cwork_profile).to respond_to(:p_path) }
        it { expect(cwork_profile).to respond_to(:as_json) }
        it { expect(cwork_profile).to respond_to(:start) }
        it { expect(cwork_profile).to respond_to(:end) }
      end

      context "executes methods correctly" do
        let(:user) { create(:user) }
        context "has_worker" do
          it 'do not have worker if profile and access_code is nil' do
            cwork_profile.clear_worker
            expect(cwork_profile.has_worker?).to be_falsey
          end
          it 'do have worker if profile is not nil' do
            expect(cwork_profile.has_worker?).to be_truthy
          end
          it 'do have worker if access_code is not nil' do
            expect(cwork_access.has_worker?).to be_truthy
          end
        end
        context "add_worker" do
          it 'add worker with params and no user' do
            cwork_no_worker.add_worker(attributes_for(:cafe_work,:worker), nil)
            expect(cwork_no_worker.has_worker?).to be_truthy
          end
          it 'add worker with params and no user, has access_code' do
            cwork_no_worker.add_worker(attributes_for(:cafe_work,:worker), nil)
            expect(cwork_no_worker.access_code).to_not be_nil
          end
          it 'add worker with params and with user' do
            cwork_no_worker.add_worker(attributes_for(:cafe_work,:worker), user)
            expect(cwork_no_worker.has_worker?).to be_truthy
          end
          it 'add worker with params and user, have profile' do
            cwork_no_worker.add_worker(attributes_for(:cafe_work,:worker), user)
            expect(cwork_no_worker.profile).to eq(user.profile)
          end
        end
        context "remove_worker" do
          it 'with the right user' do
            cwork_profile.profile = user.profile
            cwork_profile.remove_worker(user, nil)
            expect(cwork_no_worker.profile).to be_nil
          end
          it 'with the wrong user' do
            cwork_profile.remove_worker(user, nil)
            expect(cwork_profile.profile).to_not be_nil
          end
          it 'with right access_code' do
            access = cwork_access.access_code
            cwork_access.remove_worker(nil, access)
            expect(cwork_access.has_worker?).to be_falsey
          end
          it 'with right access_code' do
            access = 'wrong code'
            cwork_access.remove_worker(nil, access)
            expect(cwork_access.has_worker?).to be_truthy
          end
        end
        context "update_worker" do
          it 'update worker with user' do
            cwork_profile.profile = user.profile
            cwork_profile.update_worker(attributes_for(:cafe_work, lastname: 'Wessman'), user)
            expect(cwork_profile.lastname).to eq('Wessman')
          end
        end
      end
    end
  end
end
