FactoryBot.define do
  factory :work_post do
    title
    description
    kind { %w[Sommarjobb Examensarbete Deltid].sample }
    company { %w[IKEA Axis Sony Flatfrog].sample }
    target_group { ['Teknisk matematik', 'Teknisk fysik', 'Teknisk nanovetenskap'].sample }
    field { %w[Fysik IT Ekonomi].sample }
    deadline { Time.zone.now + 10.days }
    visible { true }
    publish { Time.zone.now - 1.days }

    trait :image do
      image { Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg')) }
    end
  end
end
