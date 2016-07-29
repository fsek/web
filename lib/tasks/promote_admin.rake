task :promote_admin => :environment do
  perm = Permission.find_or_create_by!(subject_class: :all, action: :manage)
  council = Council.find_or_create_by!(title: 'Prylmästeriet', url: 'pryl')
  position = Position.find_or_create_by!(title: 'Admin',
                                         description: 'Administratör',
                                         council: council,
                                         limit: 3,
                                         rec_limit: 0,
                                         elected_by: Position::BOARD)
  PermissionPosition.find_or_create_by!(permission: perm, position: position)
  u = User.first
  u.positions << position
  u.save!
end
