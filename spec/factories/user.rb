#encoding: UTF-8
FactoryGirl.define do
  factory :user do
    username 'FooBar'
    password '12345678'
    email 'foo@bar.com'
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
