require 'rails_helper'

RSpec.describe EventSignupHelper do
  describe 'signup_options' do
    it 'returns options' do
      signup =  build_stubbed(:event_signup, member: 10, novice: 20)
      response = helper.signup_options(signup)
      response.first.should eq([EventSignup.human_attribute_name(:novice), EventSignup::NOVICE])
      response.second.should eq([EventSignup.human_attribute_name(:member), EventSignup::MEMBER])
      response.size.should eq(2)
    end
  end
end
