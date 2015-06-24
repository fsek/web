FactoryGirl.define do
  factory :squad do |g|
    title { generate(:name) }
    category 'Nollning'
    description
    g.public true
  end
end
