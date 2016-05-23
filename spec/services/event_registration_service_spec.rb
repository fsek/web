RSpec.describe EventRegistrationService do
  let(:extended) { Class.new { extend EventRegistrationService } }
  let(:include) { Class.new { include EventRegistrationService } }

  let(:user) { create(:user) }
  let(:event) { create(:event, :registration) }

  it 'works' do
    
  end
end
