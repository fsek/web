FactoryBot.define do
  factory :group do
    name
    number { rand(1..100) }
    introduction
  end
end
