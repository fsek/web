class NominationsController < ApplicationController
  
  
  
  def create
    @valet = Election.current
    @nomination = @valet.nominations.build(nomination_params)
    respond_to do |format|
      if @nomination.save
        ElectionMailer.nominate_email(@nomination).deliver        
        format.html { redirect_to elections_path, notice: 'Nomination genomförd' }
        format.json { render action: 'show', status: :created, location: @valet }        
      else
        Rails.logger.info @nomination.errors.count
        format.html { redirect_to nominate_elections_path, notice: "Fyll i alla fält" }
        format.json { render json: @nomination.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def nomination_params
    params.fetch('/val/nominera').permit(:name,:email,:stil_id,:phone,:motivation,:election_id,:post_id)
  end
end
