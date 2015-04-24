# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    username
    email
    password '12345678'
    before(:create) { |user| user.as_f_member }

    # Overrides the :create_profile_for_user method
    after(:build) { |user| user.class.skip_callback(:create, :after, :create_profile_for_user) }

    # Needed because users cannot be created without f_validate being okay.
    to_create { |instance| instance.save!(validate: false) }
  end

  factory :admin, class: 'User' do
    username
    password '12345678'
    email
    before(:create) { |user| user.as_f_member }
    with_admin_post
  end

  trait :with_admin_post do
    posts {[create(:post, :with_admin_permissions)]}
  end
end
