task :promote_admin => :environment do
  perm = Permission.find_or_create_by!(subject_class: :all, action: :manage)
  council = Council.find_or_create_by!(title: 'Prylmästeriet', url: 'pryl')
  post = Post.find_or_create_by!(title: 'Admin',
                                 description: 'Administratör',
                                 council: council,
                                 limit: 3,
                                 rec_limit: 0,
                                 elected_by: Post::BOARD)
  PermissionPost.find_or_create_by!(permission: perm, post: post)
  u = User.first
  u.posts << post
  u.save!
end
