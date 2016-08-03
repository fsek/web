FactoryGirl.define do
  factory :event_signup do
    event
    slots 10
    last_reg { event.starts_at - 1.day }
  end
end
