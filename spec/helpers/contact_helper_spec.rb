require 'rails_helper'

RSpec.describe ContactHelper do
  describe 'contact_link' do
    it 'creates link with favicon' do
      contact = build_stubbed(:contact, email: 'spindelman@fsektionen.se',
                                        id: 10)

      result = helper.contact_link(contact)

      result.should include('kontakt/10')
    end

    it 'returns nil if no contact' do
      result = helper.contact_link(nil)

      result.should be_nil
    end
  end

  describe 'contact_from_constant' do
    it 'finds contact with constant' do
      create(:contact, id: 10, email: 'spindelman@fsektionen.se')
      create(:constant, name: 'contact_id', value: 10)

      result = helper.contact_from_constant(constant: 'contact_id')

      result.should include('kontakt/10')
    end
  end
end
