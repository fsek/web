class CandidateView
  attr_reader :election, :current, :all

  def initialize(election, current: nil, all: [])
    @election = election
    @current = current
    @all = all
  end
end
