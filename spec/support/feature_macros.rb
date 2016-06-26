module FeatureMacros
  def sign_in_as(user, path: '/')
    login_as(user, scope: :user)
    visit(path)
  end
end
