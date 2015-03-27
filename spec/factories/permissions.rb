FactoryGirl.define do
  factory :permission do
    subject_class 'News'
    action 'read'
  end
  factory :admin_permission, class: 'Permission' do
    subject_class :all
    action :manage
  end
end
