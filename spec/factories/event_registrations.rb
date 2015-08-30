FactoryGirl.define do
  factory :event_registration do
    user { create(:user) }
    event { create(:event, :registration) }
  end
end
