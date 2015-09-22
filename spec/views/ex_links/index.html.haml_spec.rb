require 'rails_helper'

RSpec.describe "ex_links/index", type: :view do
  before(:each) do
    assign(:ex_links, [
      ExLink.create!(
        :label => "Label",
        :url => "MyText",
        :tags => "Tags",
        :test_availability => false,
        :note => "MyText",
        :active => false
      ),
      ExLink.create!(
        :label => "Label",
        :url => "MyText",
        :tags => "Tags",
        :test_availability => false,
        :note => "MyText",
        :active => false
      )
    ])
  end

  it "renders a list of ex_links" do
    render
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Tags".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
