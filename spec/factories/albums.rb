# encoding: UTF-8
FactoryGirl.define do
  factory :album do
    title
    description
    public true
    start_date { Time.zone.now }
  end
end
