# encoding: UTF-8
FactoryGirl.define do
  factory :document do
    title
    pdf { fixture_file_upload(Rails.root.join('spec', 'assets', 'fpapper.pdf'), 'application/pdf') }
  end
end
