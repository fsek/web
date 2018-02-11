require 'rails_helper'

RSpec.describe(Api::SongsController, type: :controller) do
  allow_user_to([:index, :show], Api::Song)

  describe 'GET #index' do
    it 'returns songs ordered alphabetically' do
      first = Song.create(title: "Comfortably Numb", content: "CN")
      second = Song.create(title: "Brain Damage", content: "BD")
      third = Song.create(title: "Another Brick In The Wall", content: "ABITW")
      first.save!
      second.save!
      third.save!

      json = '{"songs":' + [third, second, first].to_json(only: [:id, :title]) + '}'
      get(:index)
      response.body.should eq(json)
    end
  end
end
