# encoding: UTF-8
FactoryBot.define do
  factory :faq do
    question { generate(:description) }
    answer { generate(:description) }
    category { ['Hilbert Café', 'F-bilen', 'Styrelsen'].sample }
  end
end
