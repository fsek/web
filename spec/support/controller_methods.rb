# Adds controller macros callable inside it-blocks
module ControllerMethods
  def set_current_user(user)
    controller.stub(:current_user).and_return(user)
  end
end
