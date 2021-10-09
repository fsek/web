FactoryBot.define do
  factory :permission do
    subject_class { %w[News CafeWork Post Rent Event].sample }
    action { %w[read create update manage new].sample }
  end
  factory :admin_permission, class: 'Permission' do
    subject_class { :all }
    action { :manage }
  end
end
