# encoding: UTF-8
FactoryGirl.define do
  factory :user do
    username
    password '12345678'
    firstname
    lastname
    email
    phone
    stil_id
  end

  factory :admin, class: 'User' do |user|
    username
    password '12345678'
    firstname
    lastname
    email
    phone
    stil_id
    with_admin_post
  end

  trait :with_admin_post do
    after(:create) do |user|
      create(:post_user, post: create(:post, :with_admin_permissions), user: user)
    end
  end
end
