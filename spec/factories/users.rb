#encoding: UTF-8
FactoryGirl.define do
  factory :user do
    username
    email
    # Needed because users cannot be created without f_validate being okay.
    to_create {|instance| instance.save(validate: false) }
  end
end
