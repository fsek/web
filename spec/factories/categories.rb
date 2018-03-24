FactoryBot.define do
  factory :category do
    title_sv { generate(:title) }
    title_en { "#{title_sv} - English" }
    slug { generate(:url) }
  end
end
