FactoryGirl.define do
  factory :ex_link do
    label 'MyString'
    url 'MyText'
    tags 'MyString'
    test_availability false
    note 'MyText'
    active false
    expiration '2015-09-22'
  end
end