# encoding: UTF-8
FactoryGirl.define do
  factory :menu do
    location { ['Sektionen', 'För medlemmar', 'För företag', 'Kontakt'].sample }
    index { rand(10..100) }
    link { generate(:url) }
    visible true
    turbolinks true
    blank_p false
  end
end
