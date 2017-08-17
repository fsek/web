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

  def robots
    render :robots, content_type: 'text/plain'
  end

  def privacy
  end

  def index
    member = current_user.present? && current_user.member?
    @start_page = StartPage.new(member: member)
  end
end
