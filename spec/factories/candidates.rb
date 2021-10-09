FactoryBot.define do
  factory :candidate do |_c|
    association :election, semester: Post::AUTUMN
    association :post, semester: Post::AUTUMN
    user
  end
end
