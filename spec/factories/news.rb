# encoding: UTF-8
FactoryBot.define do
  factory :news do
    title
    content { generate(:description) }
    user

    trait :with_image do
      image Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg'))
    end
  end
end
