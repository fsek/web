require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  before(:each) do
    assign(:groups, [
      Group.create!(
        :category => "Category",
        :boolean => ""
      ),
      Group.create!(
        :category => "Category",
        :boolean => ""
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
