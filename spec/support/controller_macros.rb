# Adds controller macros callable outside of it-blocks
module ControllerMacros
  RSpec.configure do |config|
    config.before :each, type: :controller do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability).and_return(@ability)
      controller.stub(:load_permissions).and_return(nil)
      @admin_ability = Object.new
      @admin_ability.extend(CanCan::Ability)
      controller.stub(:current_admin_ability).and_return(@admin_ability)
    end
  end

  def allow_user_to(*args)
    before(:each) do
      @ability.can(*args)
    end
  end

  def allow_user_to_admin(*args)
    before(:each) do
      @admin_ability.can(*args)
    end
  end
end
