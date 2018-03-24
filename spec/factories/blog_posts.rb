FactoryBot.define do
  factory :blog_post do
    title
    preamble { generate(:description) }
    content { generate(:description) }
    user
  end
end
