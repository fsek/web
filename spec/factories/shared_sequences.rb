#encoding: UTF-8
FactoryGirl.define do
  sequence(:email) { |n| "d.wessman#{n}@live.se" }
  sequence(:phone) { |n| "070#{n}607889" }
  sequence(:access_code) { |n| "#{n}" }
  sequence(:title) { |n| "Titel#{n}" }
  sequence(:url) { |n| "url#{n}" }
  sequence(:name) { |n| "David#{n}" }
  sequence(:lastname) { |n| "Wessman#{n}" }
  sequence(:value) { |n| "david#{n}" }
end