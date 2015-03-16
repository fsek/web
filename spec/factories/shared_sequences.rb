#encoding: UTF-8
FactoryGirl.define do
  sequence(:email) { |n| "d.wessman#{n}@live.se" }
  sequence(:phone) { |n| "070#{n}607889" }
  sequence(:title) { |n| "Titel#{n}" }
  sequence(:url) { |n| "url#{n}" }
  sequence(:name) { |n| "David#{n}" }
  sequence(:lastname) { |n| "Wessman#{n}" }
  sequence(:value) { |n| "david#{n}" }
  sequence(:access_code) { (0...15).map { (65 + rand(26)).chr }.join.to_s }
end