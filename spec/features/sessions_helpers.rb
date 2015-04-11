module Features
	module SessionHelpers
		def sign_in(user)
			visit sign_in_path
    	fill_in 'user_username', with: user.username
    	fill_in 'user_password', with: '12345678'
    	click_button I18n.t('devise.sign_in') 
		end
	end
end
