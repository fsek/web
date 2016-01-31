# encoding: UTF-8
FactoryGirl.define do
  factory :menu do
    name
    location do
      [Menu::GUILD, Menu::MEMBER, Menu::COMPANY, Menu::CONTACT].sample
    end
    index { rand(10..100) }
    link { generate(:url) }
    visible true
    turbolinks true
    blank_p false
  end
end
