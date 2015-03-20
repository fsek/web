FactoryGirl.define do
  factory :role do
    initialize_with { Role.where(title: 'role').first_or_create }
    name 'A role'
    title 'role'
    description 'A role description'
  end

  factory :admin_role, class: Role do
    initialize_with { Role.where(title: 'admin').first_or_create }
    name 'The admin role'
    title 'admin'
    description 'An admin'
    the_role '{"system":{"administrator":true}}'
  end
end
