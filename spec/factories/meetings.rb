FactoryBot.define do
  factory :meeting do
    user
    start_date { 1.days.from_now }
    end_date { start_date + 2.hours }
    title
    room { :sk }
    status { :unconfirmed }
  end
end
