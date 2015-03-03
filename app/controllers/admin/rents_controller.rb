class Admin::RentsController < ApplicationController
  before_action :login_required

  def main
    @rents = Rent.ascending.from_date(Time.zone.now.beginning_of_day)
    @rent_grid = initialize_grid(@rents)
    @faqs =  Faq.where(answer: '').where(category: 'Bil')
  end
end
