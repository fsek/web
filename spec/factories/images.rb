# encoding: UTF-8
FactoryBot.define do
  factory :image do
    album
    photographer { FactoryBot.create(:user) }
    file Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg'))
    filename { generate(:firstname) }
  end
end
