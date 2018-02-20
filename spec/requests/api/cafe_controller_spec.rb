require 'rails_helper'

RSpec.describe(Api::CafeController, type: :request) do
  let(:user) { create(:user) }

  before do
    @headers = user.create_new_auth_token
  end

  describe 'GET #index' do
    24.times.step(2) do |timespan|
      CafeShift.new(Time.now + timespan.hours, 2)
    end
    it 'returns all cafe shifts between specified dates' do
      get api_cafe_path(start: Time.now, end: Time.now + 1.day), headers: @headers
      response.body.length.should eq(12)
    end
  end
end
