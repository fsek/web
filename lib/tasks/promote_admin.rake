require 'factory_girl'

task :promote_admin => :environment do
  perm = Permission.find_or_create_by!(subject_class: :all, action: :manage)
  post = Post.find_or_create_by!(title: 'Admin', description: 'Administratör')
  PermissionPost.find_or_create_by!(permission: perm, post: post)
  u = User.first
  u.posts << post
  u.save!
end
