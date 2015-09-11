# encoding: UTF-8
FactoryGirl.define do
  factory :document do
    title
    pdf_file_name { generate(:name) }
    pdf_content_type { 'application/pdf' }
    pdf_file_size 1024
  end
end
