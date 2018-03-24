FactoryBot.define do
  factory :main_menu do
    name
    index { rand(10..100) }
    mega false
  end
end
