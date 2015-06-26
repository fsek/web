FactoryGirl.define do
  factory :group do |g|
    title { generate(:name) }
    category 'Nollning'
    description
    g.public true
  end
end
