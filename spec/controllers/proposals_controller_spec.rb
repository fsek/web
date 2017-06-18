require 'rails_helper'

RSpec.describe ProposalsController, type: :controller do
  describe '#generate' do
    render_views

    it 'doesn\'t die horribly when you try to use it' do
      attributes = { title: 'my proposal', points: [''] }
      lambda do
        post :generate, format: :pdf, params: { proposal: attributes }
      end.should_not raise_error
      response.should be_success
    end
  end
end

