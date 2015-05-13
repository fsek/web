# encoding: UTF-8
FactoryGirl.define do
  factory :assignee do
    firstname
    lastname
    email
    phone

    trait :test do
      firstname 'Test'
      lastname 'Testaren'
      email 'tests@tes.t'
      phone '7357'
    end

    trait :invalid do
      firstname ''
      lastname ''
      email ''
      phone ''
    end
  end
end
