# encoding: UTF-8
FactoryGirl.define do
  factory :notice do
    title
    description
    public true
    d_publish { Time.zone.now }
    d_remove { d_publish + 10.days }
    sort { rand(10..100) }
  end
end
