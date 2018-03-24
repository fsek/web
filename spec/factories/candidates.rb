FactoryBot.define do
  factory :candidate do |c|
    association :election, semester: Post::AUTUMN
    association :post, semester: Post::AUTUMN
    user
  end
end
