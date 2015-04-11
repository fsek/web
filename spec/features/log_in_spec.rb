require 'rails_helper'
feature 'User sign in' do
	let(:user) { create(:user) }

	Steps 'Signing in with correct credentials' do
		When 'I go to sign in page' do
			page.visit new_user_session_path
		end
		And 'I fill in right username' do
			page.fill_in 'user_username', with: user.username
		end
		And 'I fill in  right password' do
			page.fill_in 'user_password', with: '12345678'
		end
		And 'I click login' do
			page.click_button I18n.t('devise.sign_in') 
		end
		Then 'I should see greeting' do
    	page.should have_css('div.alert.alert-info') 
    	find('div.alert.alert-info').text.should include(I18n.t('devise.sessions.signed_in')) 
		end
	end

	Steps 'User tries to sign in with incorrect password' do
		When 'I go to sign in page' do
			page.visit new_user_session_path
		end
		And 'I fill in right username' do
			page.fill_in 'user_username', with: user.username
		end
		And 'I fill in wrong password' do
			page.fill_in 'user_password', with: 'wrong'
		end
		And 'I click login' do
			page.click_button I18n.t('devise.sign_in') 
		end
		Then 'I should see error' do
			page.should have_content(I18n.t('devise.failure.invalid'))
		end
	end
end
