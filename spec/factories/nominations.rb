FactoryBot.define do
  factory :nomination do
    name
    email
    motivation { generate(:description) }
    association :election, semester: Post::AUTUMN
    association :post, semester: Post::AUTUMN
  end
end
