require 'rails_helper'

RSpec.feature 'admin visits paths' do
  let(:user) { create(:admin) }

  paths = {
    'admin/cafe': [:index, :overview],
    'admin/cafe_shifts': [:new, :edit, :show, :setup],
    'admin/categories': [:new, :edit, :index],
    'admin/constants': [:index, :new, :show],
    'admin/contacts': [:new, :edit, :index],
    'admin/councils': [:new, :edit, :index],
    'admin/documents': [:new, :edit, :index],
    'admin/doors': [:new, :edit, :index],
    'admin/elections': [:new, :index, :show, :edit],
    'admin/events': [:edit, :new, :index],
    'admin/faqs': [:index, :edit, :new],
    'admin/albums': [:index, :show],
    'admin/menus': [:index, :new, :edit],
    'admin/news': [:index, :new, :edit],
    'admin/pages': [:index, :new, :edit],
    'admin/permissions': [:index],
    'admin/rents': [:index, :show, :new],
    'admin/tools': [:index, :edit, :new],
    'admin/users': [:index],
    'admin/work_posts': [:index, :new, :edit],
    cafe: [:ladybug]
  }

  include ControllerMacros
  before(:each) do
    sign_in_as(user)
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
