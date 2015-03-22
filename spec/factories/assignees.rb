# encoding: UTF-8
FactoryGirl.define do
  factory :assignee do
    name
    lastname
    email
    phone

    trait :test do
      name 'Test'
      lastname 'Testaren'
      email 'tests@tes.t'
      phone '7357'
    end

    trait :invalid do
      name ''
      lastname ''
      email ''
      phone ''
    end
  end
end
