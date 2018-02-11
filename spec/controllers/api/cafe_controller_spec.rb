require 'rails_helper'

RSpec.describe(Api::CafeController, type: :controller) do
  allow_user_to([:index, :create, :destroy], Api::Cafe)

  describe 'GET #index' do
    it 'returns all cafe shifts between specified dates' do
      10.times do |timespan|
    end
  end
end
