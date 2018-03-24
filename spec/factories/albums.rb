# encoding: UTF-8
FactoryBot.define do
  factory :album do
    title
    description
    start_date { Time.zone.now.beginning_of_day + 10.hours }
    end_date { Time.zone.now.beginning_of_day + 20.hours }

    factory :album_with_images do
      transient do
        image_count 2
      end

      after(:create) do |album, evaluator|
        create_list(:image, evaluator.image_count, album: album)
      end
    end
  end
end
