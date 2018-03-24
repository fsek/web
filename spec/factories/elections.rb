FactoryBot.define do
  factory :election do
    title
    url
    open { 2.days.ago }
    close_general { 5.days.from_now }
    close_all { 7.days.from_now }
    visible true
    description
    candidate_mail_star { generate(:email) }
    mail_link { generate(:email) }
    board_mail_link { generate(:email) }
    semester { [Post::AUTUMN, Post::SPRING].sample }

    trait :not_opened do
      open { 2.days.from_now }
      close_general { 5.days.from_now }
      close_all { 7.days.from_now }
    end

    trait :before_general do
      open { 2.days.ago }
      close_general { 5.days.from_now }
      close_all { 7.days.from_now }
    end

    trait :after_general do
      open { 5.days.ago }
      close_general { 1.days.ago }
      close_all { 7.days.from_now }
    end

    trait :closed do
      open { 7.days.ago }
      close_general { 5.days.ago }
      close_all { 2.days.ago }
    end

    trait :autumn do
      semester Post::AUTUMN
    end

    trait :spring do
      semester Post::SPRING
    end

    trait :other do
      semester Post::OTHER
    end
  end
end
