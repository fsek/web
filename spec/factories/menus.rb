FactoryBot.define do
  factory :menu do
    name
    main_menu
    index { rand(10..100) }
    link { generate(:url) }
    visible true
    turbolinks true
    blank_p false
  end
end
