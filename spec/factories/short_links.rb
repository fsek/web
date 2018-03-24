FactoryBot.define do
  factory :short_link do
    link 'my_awesomeshort-link0'
    target 'http://randomwebpage.com:80/some/resource/yeah?q=asdf&yeah='
  end
end

