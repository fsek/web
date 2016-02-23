FactoryGirl.define do
  factory :election do
    title
    url
    start { 2.days.ago }
    stop { 5.days.from_now }
    closing { 7.days.from_now }
    visible true
    description
    candidate_mail_star { generate(:email) }
    mail_link { generate(:email) }
    board_mail_link { generate(:email) }
    semester { [Post::AUTUMN, Post::SPRING].sample }

    trait :before do
      start { 2.days.from_now }
      stop { 5.days.from_now }
      closing { 7.days.from_now }
    end

    trait :during do
      start { 2.days.ago }
      stop { 5.days.from_now }
      closing { 7.days.from_now }
    end

    trait :after do
      start { 5.days.ago }
      stop { 1.days.ago }
      closing { 7.days.from_now }
    end

    trait :closed do
      start { 7.days.ago }
      stop { 5.days.ago }
      closing { 2.days.ago }
    end
  end
end
