# encoding: UTF-8
FactoryGirl.define do
  factory :image do
    album
    photographer { FactoryGirl.create(:user) }
    file { File.open('app/assets/images/hilbert.jpg') }
    filename { generate(:firstname) }
  end
end
