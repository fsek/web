require 'rails_helper'

RSpec.describe "ex_links/new", type: :view do
  before(:each) do
    assign(:ex_link, ExLink.new(
      :label => "MyString",
      :url => "MyText",
      :tags => "MyString",
      :test_availability => false,
      :note => "MyText",
      :active => false
    ))
  end

  it "renders new ex_link form" do
    render

    assert_select "form[action=?][method=?]", ex_links_path, "post" do

      assert_select "input#ex_link_label[name=?]", "ex_link[label]"

      assert_select "textarea#ex_link_url[name=?]", "ex_link[url]"

      assert_select "input#ex_link_tags[name=?]", "ex_link[tags]"

      assert_select "input#ex_link_test_availability[name=?]", "ex_link[test_availability]"

      assert_select "textarea#ex_link_note[name=?]", "ex_link[note]"

      assert_select "input#ex_link_active[name=?]", "ex_link[active]"
    end
  end
end
