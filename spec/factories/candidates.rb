FactoryGirl.define do
  factory :candidate do |c|
    election
    email
    lastname
    name
    phone
    c.post
    profile
    stil_id

    # Override after_create callbacks.
    after(:build) { |candidate| candidate.class.skip_callback(:create, :after, :send_email, :overbook_all) }

    # Trait to use while testing send_email after_create callback
    trait :with_send_email do
      after(:build) { |candidate| candidate.class.set_callback(:create, :after, :send_email) }
    end
  end
end