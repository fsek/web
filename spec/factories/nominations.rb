FactoryGirl.define do
  factory :nomination do
    name
    email
    motivation { generate(:description) }
    association :election, semester: Position::AUTUMN
    association :position, semester: Position::AUTUMN
  end
end
