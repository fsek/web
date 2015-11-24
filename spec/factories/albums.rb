# encoding: UTF-8
FactoryGirl.define do
  factory :album do
    title
    description
    start_date { Time.zone.now }

    factory :album_with_images do
      transient do
        image_count 5
      end

      after(:create) do |album, evaluator|
        create_list(:image, evaluator.image_count, album: album)
      end
    end
  end
end
