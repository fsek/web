require 'rails_helper'

RSpec.describe CafeWork, type: :model do
  it "has a valid factory" do
    (build(:cafe_work)).should be_valid
  end

  let(:user) { create(:user)}
  let(:not_owner) { create(:user)}
  let(:cwork_profile) { create(:cafe_work, :w_profile, profile: user.profile) }
  let(:cwork_access) { create(:cafe_work, :access) }
  let(:cwork_no_worker) { create(:cafe_work) }
  subject(:cwork) { build(:cafe_work) }

  describe 'ActiveModel validations' do
    # Basic validations
    it { should validate_presence_of(:work_day) }
    it { should validate_presence_of(:pass) }
    it { should validate_presence_of(:lp) }
    it { should validate_presence_of(:lv) }
    it { should validate_inclusion_of(:pass).in_range(1..4) }
    it { should validate_inclusion_of(:lp).in_range(1..4) }
    it { should validate_inclusion_of(:lv).in_range(1..7) }

    context 'if has_worker' do
      before { allow(subject).to receive(:has_worker?).and_return(true) }
      it { subject.should validate_presence_of(:name) }
      it { subject.should validate_presence_of(:lastname) }
      it { subject.should validate_presence_of(:phone) }
      it { subject.should validate_presence_of(:email) }
    end

  end

  describe "ActiveRecord associations" do
    # Associations
    it { should belong_to(:profile) }
    it { should have_many(:cafe_work_councils) }
    it { should have_many(:councils) }
  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { should respond_to(:send_email) }
      it { should respond_to(:load) }
      it { should respond_to(:status_text) }
      it { should respond_to(:status_view) }
      it { should respond_to(:add_or_update) }
      it { should respond_to(:add_worker) }
      it { should respond_to(:update_worker) }
      it { should respond_to(:remove_worker) }
      it { should respond_to(:clear_worker) }
      it { should respond_to(:owner?) }
      it { should respond_to(:edit?) }
      it { should respond_to(:authorize) }
      it { should respond_to(:has_worker?) }
      it { should respond_to(:print_time) }
      it { should respond_to(:print) }
      it { should respond_to(:print_date) }
      it { should respond_to(:p_url) }
      it { should respond_to(:p_path) }
      it { should respond_to(:as_json) }
      it { should respond_to(:start) }
      it { should respond_to(:stop) }
    end

    context "executes methods correctly" do
      let(:user) { create(:user) }
      context "has_worker" do
        it 'do not have worker if profile and access_code is nil' do
          cwork_profile.clear_worker
          (cwork_profile.has_worker?).should be_falsey
        end
        it 'do have worker if profile is not nil' do
          (cwork_profile.has_worker?).should be_truthy
        end
        it 'do have worker if access_code is not nil' do
          (cwork_access.has_worker?).should be_truthy
        end
      end

      context "add_worker" do
        it 'add worker with params and no user' do
          cwork_no_worker.add_worker(attributes_for(:assignee), nil)
          (cwork_no_worker.has_worker?).should be_truthy
        end
        it 'add worker with params and no user, has access_code' do
          cwork_no_worker.add_worker(attributes_for(:assignee), nil)
          (cwork_no_worker.access_code).should_not be_nil
        end
        it 'add worker with params and with user' do
          cwork_no_worker.add_worker(attributes_for(:assignee), user)
          (cwork_no_worker.has_worker?).should be_truthy
        end
        it 'add worker with params and user, have profile' do
          cwork_no_worker.add_worker(attributes_for(:assignee), user)
          (cwork_no_worker.profile).should eq(user.profile)
        end
      end

      context "remove_worker" do
        it 'with the right user' do
          cwork_profile.remove_worker(user, nil)
          (cwork_no_worker.worker.profile).should be_nil
        end
        it 'with the wrong user' do
          cwork_profile.remove_worker(not_owner, nil)
          (cwork_profile.worker.profile).should_not be_nil
        end
        it 'with right access_code' do
          access = cwork_access.access_code
          cwork_access.remove_worker(nil, access)
          (cwork_access.has_worker?).should be_falsey
        end
        it 'with right access_code' do
          access = 'wrong code'
          cwork_access.remove_worker(nil, access)
          (cwork_access.has_worker?).should be_truthy
        end
      end

      context 'update_worker' do
        it 'update worker with user' do
          cwork_profile.profile = user.profile
          cwork_profile.update_worker(attributes_for(:assignee, lastname: 'Wessman'), user)
          (cwork_profile.lastname).should eq('Wessman')
        end
      end

      context 'status_view' do
        it 'should return :sign_up for cwork' do
          cwork_no_worker.status_view(nil).should eq(:sign_up)
        end
        it 'should return :edit for cwork_profile' do
          cwork_profile.status_view(user).should eq(:edit)
        end
        it 'should return :authorize for cwork_profile' do
          cwork_access.status_view(user).should eq(:authorize)
        end
        it 'should return :assigned for cwork_profile' do
          cwork_profile.status_view(not_owner).should eq(:assigned)
        end
      end
    end
    # This tests makes sure that dates are formatted into ISO8601 for
    # Fullcalendars json-feed
    # Ref.: https://github.com/fsek/web/issues/99
    # /d.wessman
    describe :Json do
      it 'check date format is iso8601' do
        (cwork_profile.as_json.to_json).should include(cwork_profile.start.iso8601.to_json)
        (cwork_profile.as_json.to_json).should include(cwork_profile.stop.iso8601.to_json)
      end
      it 'as_json request is processed with parameters' do
        (cwork_profile.as_json('params').to_json).should include(cwork_profile.start.iso8601.to_json)
      end
    end
  end
end
