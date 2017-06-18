require 'rails_helper'

RSpec.describe GalleryController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to :manage, :gallery
  allow_user_to :manage, Album

  before(:each) do
    set_current_user(user)
    user.stub(:summerchild?).and_return(false)
  end

  describe 'GET #index' do
    it 'assigns albums for current year as @albums' do
      create(:album, images_count: 5, title: 'Shown')
      create(:album, images_count: 5, title: 'Not shown', start_date: 1.year.ago)

      get(:index)
      assigns(:albums).map(&:title).should eq(['Shown'])
    end

    it 'assigns albums for assigned year as @albums' do
      create(:album, images_count: 5, title: 'Not shown')
      create(:album, images_count: 5, title: 'Shown', start_date: 1.year.ago)

      get :index, params: { year: 1.year.ago.year }
      assigns(:albums).map(&:title).should eq(['Shown'])
    end
  end
end
