require 'spec_helper'

paths = %w( / /om /utskott /val /bil /proposals/form /foretag/om /kontakt /logga_in /anvandare/registrera )

feature 'GET' do
  paths.each do |path|
    scenario path do
      visit path
      page.status_code.should eq(200)
    end
  end
end
