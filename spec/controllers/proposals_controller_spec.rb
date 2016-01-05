require 'rails_helper'

RSpec.describe ProposalsController, type: :controller do
  describe '#generate' do
    render_views

    it 'doesn\'t die horribly when you try to use it' do
      lambda do
        post :generate, format: :pdf, proposal:
          { title: 'my proposal', points: [] }
      end.should_not raise_error
      response.should be_success
    end
  end
end

