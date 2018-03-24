FactoryBot.define do
  factory :introduction do
    title_sv { generate(:title) }
    title_en { "English: #{title_sv}" }
    description
    start { 2.days.from_now }
    stop { 26.days.from_now }
    slug { generate(:url) }
    current false
  end
end
