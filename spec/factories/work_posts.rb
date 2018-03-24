# encoding: UTF-8
FactoryBot.define do
  factory :work_post do
    title
    description
    kind { ['Sommarjobb', 'Examensarbete', 'Deltid'].sample }
    company { ['IKEA', 'Axis', 'Sony', 'Flatfrog'].sample }
    target_group { ['Teknisk matematik', 'Teknisk fysik', 'Teknisk nanovetenskap'].sample }
    field { ['Fysik', 'IT', 'Ekonomi'].sample }
    deadline { Time.zone.now + 10.days }
    visible true
    publish { Time.zone.now - 1.days }

    trait :image do
      image Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg'))
    end
  end
end
