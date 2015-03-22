#encoding: UTF-8
FactoryGirl.define do
  sequence(:email) { |n| "d.wessman#{n}@live.se" }
  sequence(:phone) { |n| "070#{n}607889" }
  sequence(:title) { |n| "Titel#{n}" }
  sequence(:url) { |n| "url#{n}" }
  sequence(:name) { |n| "David#{n}" }
  sequence(:lastname) { |n| "Wessman#{n}" }
  sequence(:username) { |n| "davidwessman#{n}" }
  sequence(:value) { |n| "david#{n}" }
  sequence(:access_code) { (0...15).map { (65 + rand(26)).chr }.join.to_s }

  # Used in Bilbokning
  trait :with_profile do
    profile
  end
  trait :with_council do
    council
  end
  # Used in Cafebokning and Bilbokning
  trait :with_access_code do
    access_code
  end
end
