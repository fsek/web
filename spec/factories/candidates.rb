FactoryGirl.define do
  factory :candidate do |c|
    election
    c.post
    user

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
