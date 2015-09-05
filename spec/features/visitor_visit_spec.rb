require 'rails_helper'
feature 'visitor visits paths' do
  let(:album) { create(:album) }
  let(:cafe_work) { create(:cafe_work) }
  let(:council) { create(:council) }
  let(:election) { create(:election) }

  paths = {
    albums: [:show],
    cafe_works: [:index, :nyckelpiga],
    constants: [:index, :new, :show],
    contacts: [:index, :new, :show],
    councils: [:index, :show],
    documents: [:index, :show],
    elections: [:index],
    faqs: [:index, :show, :new],
    menus: [:index, :new],
    news: [:index, :new, :show],
    pages: [:index, :new],
    rents: [:main, :index, :new]
  }

  background do
    council
    election
  end
  paths.each do |key, value|
    value.each do |v|
      Steps %(Controller: #{key}, action: #{v}) do
        if v == :show
          resource = create(key.to_s.singularize.to_sym)
          page.visit url_for(controller: key, action: :show, id:
                             resource.to_param)
        else
          page.visit url_for(controller: key, action: v)
        end
        page.status_code.should eq(200)
      end
    end
  end
end
