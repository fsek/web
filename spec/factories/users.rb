# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    username
    email
    password '12345678'
    before(:create) { |user| user.as_f_member }

    # Overrides the :create_profile_for_user method
    after(:build) { |user| user.class.skip_callback(:create, :after, :create_profile_for_user) }

    # Uses profiles factory to create a valid profile
    after(:create) do |user, evaluator|
      create(:profile, user: user)
    end

    # Can be called to create a user with the :create_profile_for_user method
    trait :user_with_create_profile do
      after(:create) { |user| user.send(:create_profile_for_user) }
    end

    # Needed because users cannot be created without f_validate being okay.
    to_create { |instance| instance.save!(validate: false) }
  end

  factory :admin, class: 'User' do
    username
    password '12345678'
    email
    before(:create) { |user| user.as_f_member }
    after(:create) { |user| create(:profile, :with_admin_post, user: user) }
  end
end
