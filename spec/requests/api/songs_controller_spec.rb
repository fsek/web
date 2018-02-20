require 'rails_helper'

RSpec.describe('Songs', type: :request) do
  let(:user) { create(:user) }
  
  before do
    @headers = user.create_new_auth_token
    @first = Song.create(title: "Comfortably Numb", content: "CN")
    @second = Song.create(title: "Brain Damage", content: "BD")
    @third = Song.create(title: "Another Brick In The Wall", content: "ABITW")
    @first.save!
    @second.save!
    @third.save!
  end

  describe 'GET #index' do
    it 'returns songs ordered alphabetically' do
      json = '{"songs":' + [@third, @second, @first].to_json(only: [:id, :title]) + '}'
      get api_songs_path, headers: @headers
      response.body.should eq(json)
    end
  end

  describe 'GET #show' do
    it 'returns song corresponding to id' do
      song = Api::SongSerializer::Show.new(@first)
      json_song = '{"song":' + song.to_json + '}'
      get api_song_path(id: 1), headers: @headers
      response.body.should eq(json_song)
    end
  end
end
