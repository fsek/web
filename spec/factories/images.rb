# encoding: UTF-8
FactoryGirl.define do
  factory :image do
    album
    photographer { FactoryGirl.create(:user) }
  end
end

