class ProposalsController < ApplicationController
  def form
    @proposal = Proposal.new
    @proposal.points = ['']
  end

  def generate
    @proposal = Proposal.new proposal_params
  end

  private

  def proposal_params
    params.require(:proposal).permit(:title, :body, :sign_name, :sign_title, points: [])
  end
end
