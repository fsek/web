require 'rails_helper'
RSpec.feature 'visitor visits paths' do
  paths = {
    cafe: [:index],
    constants: [:index, :new, :show],
    contacts: [:index, :show],
    councils: [:index, :show],
    documents: [:index, :show],
    elections: [:index],
    gallery: [:index],
    news: [:index, :show],
    pages: [:show],
    rents: [:main, :index, :new],
    static_pages: [:about, :company_offer, :company_about]
  }

  background do
    create(:notice)
    create(:news)
    create(:event)
    create(:council)
    create(:election)
  end

  paths.each do |key, value|
    value.each do |v|
      scenario %(controller: #{key}, action: #{v}) do
        if v == :show || v == :edit
          resource = create(key.to_s.split('/').last.singularize.to_sym)
          page.visit url_for(controller: key, action: v, id:
                             resource.to_param)
        else
          page.visit url_for(controller: key, action: v)
        end
        page.status_code.should eq(200)
      end
    end
  end
end
