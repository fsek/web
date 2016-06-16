require 'rails_helper'

# Dummy class for testing controller_authorization module
class Controller
  extend ControllerAuthorization

  def self.name
    'Admin::TestingsController'
  end
end

# Dummy class for testing permission method
class Testing
end

describe ControllerAuthorization, type: :concern do
  let(:controller) { Controller.new }
  subject { controller }

  describe '#permission' do
    it 'returns constantized name' do
      Controller.permission.should eq(Testing.name)
    end

    it 'returns nil if no name' do
      Controller.stub(:name) { nil }
      Controller.permission.should be_nil
    end
  end
end
