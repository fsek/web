# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    email
    password '12345678'
    firstname
    lastname
    phone
    student_id
    confirmed_at { 10.days.ago }
    member_at { 10.days.ago }

    trait :admin do
      password '12345678'
      with_admin_position
    end
  end

  factory :admin, class: 'User' do
    email
    password '12345678'
    firstname
    lastname
    phone
    student_id
    confirmed_at { Time.zone.now }
    member_at { Time.zone.now }
    with_admin_position
  end

  trait :with_admin_position do
    after(:create) do |user|
      create(:position_user, position: create(:position, :with_admin_permissions), user: user)
    end
  end

  trait :unconfirmed do
    confirmed_at nil
    confirmation_token 'confirmmyaccount'
    confirmation_sent_at { Time.zone.now }
  end

  trait :reset_password do
    reset_password_token 'resetmypassword'
    reset_password_sent_at { Time.zone.now }
  end

  trait :not_member do
    member_at nil
  end
end
