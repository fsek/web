require 'rails_helper'

RSpec.describe CafeWork, type: :model do

  it "has a valid factory" do
    # Using the shortened version of FactoryGirl syntax.
    # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:cafe_work)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:c_work) { build(:cafe_work) }
  subject(:saved) { FactoryGirl.create(:cafe_work) }
  describe "ActiveModel validations" do
    # http://guides.rubyonrails.org/active_record_validations.html
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveModel

    # Basic validations
    it { expect(c_work).to validate_presence_of(:work_day) }
    it { expect(c_work).to validate_presence_of(:pass) }
    it { expect(c_work).to validate_presence_of(:lp) }
    it { expect(c_work).to validate_presence_of(:lv) }
    context "if has_worker" do
      before { allow(saved).to receive(:has_worker?).and_return(true) }
      it { expect(saved).to validate_presence_of(:name) }
      it { expect(saved).to validate_presence_of(:lastname) }
      it { expect(saved).to validate_presence_of(:phone) }
      it { expect(saved).to validate_presence_of(:email) }
    end

    # Format validations
    #it { expect(user).to allow_value("JSON Vorhees").for(:name) }
    #it { expect(user).to_not allow_value("Java").for(:favorite_programming_language) }
    #it { expect(user).to allow_value("dhh@nonopinionated.com").for(:email) }
    #it { expect(user).to_not allow_value("base@example").for(:email) }
    #it { expect(user).to_not allow_value("blah").for(:email) }
    #it { expect(blog).to allow_blank(:connect_to_facebook) }
    #it { expect(blog).to allow_nil(:connect_to_facebook) }
  end

  describe "ActiveRecord associations" do
    # Performance tip: stub out as many on create methods as you can when you're testing validations
    # since the test suite will slow down due to having to run them all for each validation check.
    #
    # For example, assume a User has three methods that fire after one is created, stub them like this:
    #
    # before(:each) do
    #   User.any_instance.stub(:send_welcome_email)
    #   User.any_instance.stub(:track_new_user_signup)
    #   User.any_instance.stub(:method_that_takes_ten_seconds_to_complete)
    # end
    #
    # If you performed 5-10 validation checks against a User, that would save a ton of time.

    # Associations
    it { expect(c_work).to belong_to(:profile) }
    it { expect(c_work).to have_and_belong_to_many(:councils) }

    # Databse columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    #it { expect(user).to have_db_column(:political_stance).of_type(:string).with_options(default: 'undecided', null: false)
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord:have_db_index
    #it { expect(user).to have_db_index(:email).unique(:true)
  end

  context "callbacks" do
    # http://guides.rubyonrails.org/active_record_callbacks.html
    # https://github.com/beatrichartz/shoulda-callback-matchers/wiki

    #describe "scopes" do
    # It's a good idea to create specs that test a failing result for each scope, but that's up to you
    # it ".loved returns all votes with a score > 0" do
    #  product = create(:product)
    # love_vote = create(:vote, score: 1, product_id: product.id)
    #expect(Vote.loved.first).to eq(love_vote)
    #end

    #it "has another scope that works" do
    # expect(model.scope_name(conditions)).to eq(result_expected)
    #end
    #end

    describe "public instance methods" do
      context "responds to its methods" do
        it { expect(saved).to respond_to(:send_email) }
        it { expect(saved).to respond_to(:load) }
        it { expect(saved).to respond_to(:status_text) }
        it { expect(saved).to respond_to(:status_view) }
        it { expect(saved).to respond_to(:add_worker) }
        it { expect(saved).to respond_to(:update_worker) }
        it { expect(saved).to respond_to(:remove_worker) }
        it { expect(saved).to respond_to(:clear_worker) }
        it { expect(saved).to respond_to(:owner?) }
        it { expect(saved).to respond_to(:edit?) }
        it { expect(saved).to respond_to(:authorize) }
        it { expect(saved).to respond_to(:has_worker?) }
        it { expect(saved).to respond_to(:print_time) }
        it { expect(saved).to respond_to(:print) }
        it { expect(saved).to respond_to(:print_date) }
        it { expect(saved).to respond_to(:p_url) }
        it { expect(saved).to respond_to(:p_path) }
        it { expect(saved).to respond_to(:as_json) }
        it { expect(saved).to respond_to(:start) }
        it { expect(saved).to respond_to(:end) }
      end

      context "executes methods correctly" do
        subject(:user) { FactoryGirl.create(:user) }
        context "has_worker" do
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
        end
        context "add_worker" do
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
        end
        context "remove_worker" do
          it 'add worker with params and no user' do
            r = FactoryGirl.create(:cafe_work, :with_profile)
            allow(r).to receive(:owner?).and_return(true)
            r.remove_worker(FactoryGirl.attributes_for(:cafe_work), nil)
            expect(r.profile).to be_nil
          end
        end
        context "update_worker" do
          it 'update worker with user' do
            r = FactoryGirl.create(:cafe_work)
            r.profile = user.profile
            r.update_worker(FactoryGirl.attributes_for(:cafe_work, lastname: "Wessman"), user)
            expect(r.lastname).to eq("Wessman")
          end
        end
      end
    end
  end
end