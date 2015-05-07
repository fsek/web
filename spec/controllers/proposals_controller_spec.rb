require 'spec_helper'

describe ProposalsController, :type => :controller do
  describe '#generate' do
    it 'doesn\'t die horribly when you try to use it' do
      lambda do
        post :generate, :format => :pdf, :proposal => 
          { :title => 'my proposal' }
      end.should_not raise_error
      response.should be_success
    end
  end
end

