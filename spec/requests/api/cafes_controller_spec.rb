require 'rails_helper'

RSpec.describe('Cafes', type: :request) do
  let(:user) { create(:user) }

  before do
    @user = user
    @headers = @user.create_new_auth_token
    @cs = [create(:cafe_shift, start: Time.zone.now)]
    @cs << create(:cafe_shift, start: 2.hours.from_now)
  end

  describe 'GET #index' do
    it 'returns all cafe shifts between specified dates' do
      get api_cafes_path(start: 1.day.ago, end: 1.days.from_now), headers: @headers
      res = JSON.parse response.body
      res['cafe_shifts'].count.should eq(@cs.length)
    end

    it 'does not return cafe shifts outside specified dates' do
      get api_cafes_path(start: 1.day.from_now, end: 3.days.from_now), headers: @headers
      res = JSON.parse response.body
      res['cafe_shifts'].count.should eq(0)
    end
  end

  describe 'POST #create' do
    it 'signs up to a cafe_shift' do
      cw = {user_id: @user.id}
      post api_cafes_path(cafe_shift_id: @cs.first.id, cafe_worker: cw), headers: @headers
      @cs.first.cafe_worker.should be_present
    end

    it 'fails to sign up to a non existent cafe_shift' do
      cw = {user_id: @user.id}
      id = @cs.first.id
      @cs.first.destroy!
      post api_cafes_path(cafe_shift_id: id, cafe_worker: cw), headers: @headers
      response.should have_http_status :not_found
    end
  end

  describe 'DELETE #destroy' do
    before do
      @cw = create(:cafe_worker, user: @user)
    end
    it 'destroys cafe_worker corresponding to id' do
      lambda do
        delete api_cafe_path(@cw), headers: @headers
      end.should change(CafeWorker, :count).by(-1)
    end

    it 'fails to destroy cafe_worker not connected to user' do
      @cw1 = create(:cafe_worker, user: create(:user))
      lambda do
        delete api_cafe_path(@cw1), headers: @headers
      end.should change(CafeWorker, :count).by(0)
      response.should have_http_status :unauthorized
    end

    it 'fails to destroy non existent cafe_worker' do
      @cw.destroy!
      lambda do
        delete api_cafe_path(@cw), headers: @headers
      end.should change(CafeWorker, :count).by(0)
      response.should have_http_status :not_found
    end
  end
end
