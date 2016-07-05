FactoryGirl.define do
  factory :candidate do |c|
    association :election, semester: Position::AUTUMN
    association :position, semester: Position::AUTUMN
    user
  end
end
