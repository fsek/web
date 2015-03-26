FactoryGirl.define do
  factory :user do
    username
    password '12345678'
    email
    profile
    before(:create) { |user| user.as_f_member }
    after(:create) { |user| create(:profile, user: user) }
  end

  factory :admin, class: 'User' do
    username
    password '12345678'
    email
    before(:create) { |user| user.as_f_member }
    after(:create) { |user| create(:profile, :with_admin_post, user: user) }
  end
end
