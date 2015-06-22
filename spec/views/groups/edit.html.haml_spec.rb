require 'rails_helper'

RSpec.describe "groups/edit", type: :view do
  before(:each) do
    @group = assign(:group, Group.create!(
      :category => "MyString",
      :boolean => ""
    ))
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(@group), "post" do

      assert_select "input#group_category[name=?]", "group[category]"

      assert_select "input#group_boolean[name=?]", "group[boolean]"
    end
  end
end
