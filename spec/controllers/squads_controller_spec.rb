require 'rails_helper'

RSpec.describe SquadsController, type: :controller do
  let(:squad) { create(:squad) }
  let(:valid_attr) { attributes_for(:squad) }
  let(:invalid_attr) { attributes_for(:squad, title: '') }
  let(:new_attr) { attributes_for(:squad, title: 'Blåtand') }

  allow_user_to :manage, Squad

  describe "GET #index" do
    it "assigns" do
      squad
      get :index
      assigns(:squads).should include(squad)
    end
  end

  describe "GET #show" do
    it "assigns the requested squad as @squad" do
      get :show, id: squad.to_param
      assigns(:squad).should eq(squad)
    end
  end

  describe "GET #new" do
    it "assigns a new squad as @squad" do
      get :new
      assigns(:squad).should be_a_new(Squad)
    end
  end

  describe "GET #edit" do
    it "assigns the requested squad as @squad" do
      get :edit, id: squad.to_param
      assigns(:squad).should eq(squad)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Squad" do
        lambda do
          post :create, squad: valid_attr
        end.should change(Squad, :count).by(1)
      end

      it "assigns a newly created squad as @squad" do
        post :create, squad: valid_attr
        assigns(:squad).should be_a(Squad)
        assigns(:squad).should be_persisted
      end

      it "redirects to the created squad" do
        post :create, squad: valid_attr
        response.should redirect_to(Squad.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved squad as @squad" do
        post :create, squad: invalid_attr
        assigns(:squad).should be_a_new(Squad)
      end

      it "re-renders the 'new' template" do
        post :create, squad: invalid_attr
        response.should render_template("new")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested squad" do
        patch :update, id: squad.to_param, squad: new_attr
        squad.reload
        squad.title.should eq(new_attr[:title])
      end

      it "assigns the requested squad as @squad" do
        patch :update, id: squad.to_param, squad: valid_attr
        assigns(:squad).should eq(squad)
      end

      it "redirects to the squad" do
        patch :update, id: squad.to_param, squad: valid_attr
        response.should redirect_to(squad)
      end
    end

    context "with invalid params" do
      it "assigns the squad as @squad" do
        patch :update, id: squad.to_param, squad: invalid_attr
        assigns(:squad).should eq(squad)
      end

      it "re-renders the 'edit' template" do
        patch :update, id: squad.to_param, squad: invalid_attr
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      squad
    end

    it "destroys the requested squad" do
      lambda do
        delete :destroy, id: squad.to_param
      end.should change(Squad, :count).by(-1)
    end

    it "redirects to the squads list" do
      delete :destroy, id: squad.to_param
      response.should redirect_to(squads_path)
    end
  end
end
