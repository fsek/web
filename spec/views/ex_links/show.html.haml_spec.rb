require 'rails_helper'

RSpec.describe "ex_links/show", type: :view do
  before(:each) do
    @ex_link = assign(:ex_link, ExLink.create!(
      :label => "Label",
      :url => "MyText",
      :tags => "Tags",
      :test_availability => false,
      :note => "MyText",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Tags/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
