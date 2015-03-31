require 'factory_girl'

# This sets up a permission, a post and assigns an admin user to it.
FactoryGirl.create(:admin, username: 'admin', password: 'adminadmin')
