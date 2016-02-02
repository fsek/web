# encoding:UTF-8
class StaticPagesController < ApplicationController
  load_permissions_and_authorize_resource class: :static_pages

  def about
  end

  def cookies_information
  end

  def company_offer
  end

  def company_about
  end

  def index
    @start_page = StartPage.new
  end
end
