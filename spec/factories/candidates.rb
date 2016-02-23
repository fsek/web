FactoryGirl.define do
  factory :candidate do
    association :election, semester: Post::AUTUMN
    association :post, semester: Post::AUTUMN, elected_by: Post::GENERAL
    user
  end
end
