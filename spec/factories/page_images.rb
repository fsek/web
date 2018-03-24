FactoryBot.define do
  factory :page_image do
    page
    image Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg'))
  end
end
