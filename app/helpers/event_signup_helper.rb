module EventSignupHelper
  def signup_options(signup)
    options = []
    signup.order.each do |option|
      options << [EventSignup.human_attribute_name(option), option]
    end
    options
  end
end
