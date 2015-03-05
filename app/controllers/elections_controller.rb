# encoding:UTF-8
class ElectionsController < ApplicationController
  
  before_filter :login_required, except: [:index]
  before_filter :no_election, only: [:nominate,:create_nomination,:candidate]
  
  def index
    @election = Election.current
    if(@election.instance_of?(Election))
        @grid_election = initialize_grid(@election.current_posts, name: "election")
        @grid_termins = initialize_grid(@election.posts.termins, name: "election")
    else
      @election = nil
    end        
  end


private
  def election_params
    params.fetch(:election).permit(:title,:description,:start,:end,:url,:visible,:mail_link,:mail_styrelse_link,:text_before,:text_during,:text_after,:nominate_mail,:candidate_mail,:extra_text,:candidate_mail_star,:post_ids => [])
  end
end