require 'rails_helper'

RSpec.describe AdventuresController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to(:manage, Adventure)

  describe 'GET #index' do
    it 'renders latest adventure' do
      intro = create(:introduction)

      create(:adventure, start_date: 37.days.ago, introduction: intro)
      latest = create(:adventure, start_date: 1.days.ago, introduction: intro)
      create(:adventure, start_date: 2.days.ago, introduction: intro)

      get :index, params: { introduction_id: intro }
      response.should have_http_status(200)
      assigns(:adventure).should eq(latest)
    end

    it 'displays results if they are published' do
      intro = create(:introduction)
      group1 = create(:group, introduction: intro)
      group2 = create(:group, introduction: intro)

      adventure1 = create(:adventure, introduction: intro, max_points: 37, publish_results: true)
      adventure2 = create(:adventure, introduction: intro, max_points: 37, publish_results: true)

      create(:adventure_group, adventure: adventure1, group: group1, points: 30)
      create(:adventure_group, adventure: adventure2, group: group1, points: 7)
      create(:adventure_group, adventure: adventure1, group: group2, points: 37)
      create(:adventure_group, adventure: adventure2, group: group2, points: 37)

      get :index, params: { introduction_id: intro }
      response.should have_http_status(200)

      assigns(:total).where(group: group1).first.points.should eq(37)
      assigns(:total).where(group: group2).first.points.should eq(74)
    end

    it 'does not display unpublished results' do
      intro = create(:introduction)
      group = create(:group, introduction: intro)

      adventure1 = create(:adventure, introduction: intro, max_points: 37, publish_results: true)
      adventure2 = create(:adventure, introduction: intro, max_points: 37, publish_results: false)

      create(:adventure_group, adventure: adventure1, group: group, points: 37)
      create(:adventure_group, adventure: adventure2, group: group, points: 7)

      get :index, params: { introduction_id: intro }
      response.should have_http_status(200)
      assigns(:total).where(group: group).first.points.should eq(37)
    end
  end

  describe 'GET #show' do
    it 'sets adventure' do
      intro = create(:introduction)

      adventure = create(:adventure, introduction: intro)
      create(:adventure, introduction: intro)
      create(:adventure, introduction: intro)

      get :show, params: { id: adventure.to_param, introduction_id: intro }

      response.should have_http_status(200)
      assigns(:adventure).should eq(adventure)
    end
  end
end
