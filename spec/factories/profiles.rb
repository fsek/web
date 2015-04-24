# encoding: UTF-8
FactoryGirl.define do
  factory :profile do
    name
    lastname
    email
    phone
    stil_id
  end

  trait :with_admin_post do
    posts {[create(:post, :with_admin_permissions)]}
  end
end
