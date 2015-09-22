require "rails_helper"

RSpec.describe ExLinksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ex_links").to route_to("ex_links#index")
    end

    it "routes to #new" do
      expect(:get => "/ex_links/new").to route_to("ex_links#new")
    end

    it "routes to #show" do
      expect(:get => "/ex_links/1").to route_to("ex_links#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ex_links/1/edit").to route_to("ex_links#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/ex_links").to route_to("ex_links#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ex_links/1").to route_to("ex_links#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ex_links/1").to route_to("ex_links#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/ex_links/1").to route_to("ex_links#destroy", :id => "1")
    end

  end
end
