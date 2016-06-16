require 'rails_helper'

# Dummy class for testing module
class Alert
  include Alerts
end

describe Alerts, type: :concern do
  let(:alert) { Alert.new }
  subject { alert }

  describe '#model_name' do
    it 'returns human model name' do
      model = double(:model)
      model.stub(:model_name) { model }
      model.stub(:human) { 'ModelName' }
      model.stub(:instance_of?) { true }

      alert.model_name(model).should eq('ModelName')
    end

    it 'returns nil if not Class' do
      model = double(:model)
      model.stub(:instance_of?) { false }

      alert.model_name(model).should be_nil
    end
  end

  describe 'alerts' do
    it '#alert_update' do
      alert.stub(:model_name) { 'Model' }
      alert.alert_update(nil).should eq("Model #{I18n.t('global_controller.success_update')}.")
    end

    it '#alert_create' do
      alert.stub(:model_name) { 'Model' }
      alert.alert_create(nil).should eq("Model #{I18n.t('global_controller.success_create')}.")
    end

    it '#alert_destroy' do
      alert.stub(:model_name) { 'Model' }
      alert.alert_destroy(nil).should eq("Model #{I18n.t('global_controller.success_destroy')}.")
    end
  end
end
