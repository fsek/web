FactoryGirl.define do
  sequence(:description) { |n| "This describes the most impressive nr#{n}" }
  sequence(:email) { |n| "d.wessman#{n}@fsektionen.se" }
  sequence(:lastname) { |n| "Wessman#{n}" }
  sequence(:name) { |n| "David#{n}" }
  sequence(:firstname) { |n| "David#{n}" }
  sequence(:phone) { |n| "070#{n}606122" }
  sequence(:stil_id) { |n| "tfy54dw#{n}" }
  sequence(:title) { |n| "Titel#{n}" }
  sequence(:url) { |n| "url#{n}" }
  sequence(:username) { |n| "davidwessman#{n}" }
  sequence(:value) { |n| "david#{n}" }
  sequence(:location) { ['MH:A','Hilbert','Kårhuset','Ön-ön','Sjönsjön','Bastun'].sample }
  sequence(:date) { |n| Time.zone.now + 10.days + n.days }

  trait :with_user do
    user
  end

  trait :with_council do
    council
  end
end
