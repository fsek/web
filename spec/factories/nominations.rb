FactoryGirl.define do
  factory :nomination do
    name
    email
    motivation { generate(:description) }
    association :election, semester: Post::AUTUMN
    association :post, semester: Post::AUTUMN, elected_by: Post::GENERAL

    # Override after_create callbacks.
    after(:build) do |candidate|
      candidate.class.skip_callback(:create, :after, :send_email)
    end

    # Trait to use while testing send_email after_create callback
    trait :with_send_email do
      after(:build) do |candidate|
        candidate.class.set_callback(:create, :after, :send_email)
      end
    end
  end
end
