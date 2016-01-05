require 'rails_helper'

RSpec.describe 'promote_admin' do
  include_context 'rake'

  before do
    create(:user)
  end

  it 'promotes the first user to admin' do
    subject.invoke
    Ability.new(User.first).can?(:manage, :all).should eq(true)
  end
end
