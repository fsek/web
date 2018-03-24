FactoryBot.define do
  factory :adventure do
    title
    content { generate(:description) }
    introduction
    start_date { Time.zone.now }
    end_date { start_date + 7.days }
    max_points { 37 }
  end
end
