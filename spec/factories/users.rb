FactoryGirl.define do
  factory :user do
    username
    password '12345678'
    email
    role
    before(:create) { |user| user.as_f_member }
  end

  factory :admin, class: User do
    username 'MrAdmin'
    password '12345678'
    email 'admin@foobar.com'
    association :role, factory: :admin_role
    before(:create) { |user| user.as_f_member }
  end
end
