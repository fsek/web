require "rails_helper"

RSpec.describe GroupsController, type: :controller do
  let(:user) { create(:user) }
  allow_user_to(:manage, Group)

  describe "GET #index" do
    it "gets current introduction without parameters" do
      introduction = create(:introduction, current: true)
      other_introduction = create(:introduction)

      get(:index)
      response.should have_http_status(200)

      assigns(:introduction).should eq(introduction)
      assigns(:introductions).should eq([other_introduction])
    end

    it "gets introduction with params" do
      introduction = create(:introduction, current: true)
      other_introduction = create(:introduction)

      get :index, params: {introduction_id: other_introduction.id}
      response.should have_http_status(200)

      assigns(:introduction).should eq(other_introduction)
      assigns(:introductions).should eq([introduction])
    end
  end
end
