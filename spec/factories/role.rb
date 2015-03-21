FactoryGirl.define do
  factory :role do
    name 'A role'
    title 'role'
    description 'A role description'
  end

  factory :admin_role, class: Role do
    name 'The admin role'
    title 'admin'
    description 'An admin'
    the_role '{"system":{"administrator":true}}'
  end
end
