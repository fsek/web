require 'rails_helper'

RSpec.describe CafeWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:not_owner) { create(:user) }
  let(:cwork_profile) { create(:cafe_work, :w_profile, profile: user.profile) }
  let(:cwork_access) { create(:cafe_work, :access) }
  let(:cwork) { create(:cafe_work) }

  describe "GET #index" do
    before { sign_in user }
    it "assigns all cafe_works as @cafe_works" do
      #get :index
      #expect(assigns(:cafe_works)).to eq([cafe_work])
    end
  end

  describe "GET #show" do
    it "assigns the requested cafe_work as @cwork" do
      get :show, {id: cwork.to_param}
      expect(assigns(:cwork)).to eq(cwork)
    end
  end

  describe "POST #authorize" do
    it "authorizes with right code" do
      xhr :post, :authorize, {id: cwork_access.to_param, cafe_work: { access_code: cwork_access.access_code}}
      expect(assigns(:cwork)).to eq(cwork_access)
      expect(assigns(:authenticated)).to be_truthy
    end
    it "authorizes with wrong code" do
      xhr :post, :authorize, {id: cwork_access.to_param, cafe_work: { access_code: 'wrong code'}}
      expect(assigns(:authenticated)).to be_falsey
    end
  end

  describe "GET #edit" do
    it "assigns the requested cafe_work as @cafe_work" do
      cafe_work = CafeWork.create! valid_attributes
      get :edit, {:id => cafe_work.to_param}, valid_session
      expect(assigns(:cafe_work)).to eq(cafe_work)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CafeWork" do
        expect {
          post :create, {:cafe_work => valid_attributes}, valid_session
        }.to change(CafeWork, :count).by(1)
      end

      it "assigns a newly created cafe_work as @cafe_work" do
        post :create, {:cafe_work => valid_attributes}, valid_session
        expect(assigns(:cafe_work)).to be_a(CafeWork)
        expect(assigns(:cafe_work)).to be_persisted
      end

      it "redirects to the created cafe_work" do
        post :create, {:cafe_work => valid_attributes}, valid_session
        expect(response).to redirect_to(CafeWork.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved cafe_work as @cafe_work" do
        post :create, {:cafe_work => invalid_attributes}, valid_session
        expect(assigns(:cafe_work)).to be_a_new(CafeWork)
      end

      it "re-renders the 'new' template" do
        post :create, {:cafe_work => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested cafe_work" do
        cafe_work = CafeWork.create! valid_attributes
        put :update, {:id => cafe_work.to_param, :cafe_work => new_attributes}, valid_session
        cafe_work.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested cafe_work as @cafe_work" do
        cafe_work = CafeWork.create! valid_attributes
        put :update, {:id => cafe_work.to_param, :cafe_work => valid_attributes}, valid_session
        expect(assigns(:cafe_work)).to eq(cafe_work)
      end

      it "redirects to the cafe_work" do
        cafe_work = CafeWork.create! valid_attributes
        put :update, {:id => cafe_work.to_param, :cafe_work => valid_attributes}, valid_session
        expect(response).to redirect_to(cafe_work)
      end
    end

    context "with invalid params" do
      it "assigns the cafe_work as @cafe_work" do
        cafe_work = CafeWork.create! valid_attributes
        put :update, {:id => cafe_work.to_param, :cafe_work => invalid_attributes}, valid_session
        expect(assigns(:cafe_work)).to eq(cafe_work)
      end

      it "re-renders the 'edit' template" do
        cafe_work = CafeWork.create! valid_attributes
        put :update, {:id => cafe_work.to_param, :cafe_work => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested cafe_work" do
      cafe_work = CafeWork.create! valid_attributes
      expect {
        delete :destroy, {:id => cafe_work.to_param}, valid_session
      }.to change(CafeWork, :count).by(-1)
    end

    it "redirects to the cafe_works list" do
      cafe_work = CafeWork.create! valid_attributes
      delete :destroy, {:id => cafe_work.to_param}, valid_session
      expect(response).to redirect_to(cafe_works_url)
    end
  end

end
