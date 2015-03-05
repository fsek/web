class Admin::RentsController < ApplicationController
  before_action :login_required

  def main
    @rents = Rent.ascending.from_date(Time.zone.now.beginning_of_day)
    @rent_grid = initialize_grid(@rents)
    @faqs =  Faq.where(answer: '').where(category: 'Bil')
  end

  def update
    respond_to do |format|
      if @rent.update(rent_params)
        format.html { redirect_to edit_rent_path(@rent), :notice => 'Bokningen uppdaterades.' }
        format.json { render :json => @rent, :status => :created, :location => @rent }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @rent.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_status
    respond_to do |format|
      status = @rent.status
      aktiv = @rent.aktiv
      @rent.attributes = status_params
      if @rent.save(validate: false)
        if(status != @rent.status) && (@rent.status != "Ej bestämd")
          RentMailer.status_email(@rent).deliver
        end
        if(aktiv != @rent.aktiv)
          RentMailer.active_email(@rent).deliver
        end
        format.html { redirect_to rent_path(@rent), :notice => 'Bokningen uppdaterades.' }
        format.json { render :json => @rent, :status => :created, :location => @rent }
      else
        format.html { redirect_to :action => "show" }
        format.json { render :json => @rent.errors, :status => :unprocessable_entity }
      end
    end
  end
end
