# encoding: UTF-8
FactoryBot.define do
  factory :document do
    title
    pdf Rack::Test::UploadedFile.new(File.open('spec/assets/pdf.pdf'))
    category { ['Styrdokument', 'Protokoll', 'Von Tänen'].sample }
  end
end
