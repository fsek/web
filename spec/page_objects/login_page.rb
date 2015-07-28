class LoginPage
  include Capybara::DSL

  def visit_page
    visit '/logga_in'
    self
  end

  def login(user, pass)
    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: pass
    click_button I18n.t('devise.sign_in')
  end
end
