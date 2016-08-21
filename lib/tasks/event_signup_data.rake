namespace :event do
  desc 'Loads some stuff into the database for local testing'
  task(signup: :environment) do
    introduction = Introduction.find_or_create_by!(title: 'En Ridderlig Nollning',
                                                   start: Time.zone.now.change(month: 8, day: 22).beginning_of_day,
                                                   stop: Time.zone.now.change(month: 9, day: 20).end_of_day,
                                                   slug: :ridderlig, current: true)
    bk = Group.find_or_create_by!(group_type: Group::REGULAR, name: 'Black Knight', number: 1, introduction: introduction)
    dk = Group.find_or_create_by!(group_type: Group::REGULAR, name: 'Dark Knights', number: 2, introduction: introduction)
    ok = Group.find_or_create_by!(group_type: Group::REGULAR, name: 'Ordförande Knight', number: 3, introduction: introduction)

    fadder_bk = create_user('Fadder-BK')
    nolla_bk = create_user('Nolla-1-BK')
    nolla2_bk = create_user('Nolla-2-BK')
    add_to_group(bk, fadder_bk, fadder: true)
    add_to_group(bk, nolla_bk)
    add_to_group(bk, nolla2_bk)

    fadder_dk = create_user('Fadder-DK')
    nolla_dk = create_user('Nolla-1-DK')
    nolla2_dk = create_user('Nolla-2-DK')
    add_to_group(dk, fadder_dk, fadder: true)
    add_to_group(dk, nolla_dk)
    add_to_group(dk, nolla2_dk)

    fadder_ok = create_user('Fadder-OK')
    nolla_ok = create_user('Nolla-1-OK')
    nolla2_ok = create_user('Nolla-2-OK')
    add_to_group(ok, fadder_ok, fadder: true)
    add_to_group(ok, nolla_ok)
    add_to_group(ok, nolla2_ok)
  end

  def create_user(firstname)
    user = User.find_or_initialize_by(email: "#{firstname}@fsektionen.se",
                                       firstname: firstname, lastname: 'Älg',
                                       program: 'Teknisk Fysik', start_year: 1996)
    user.food_preference = ['Mjölkprotein', 'Vegetarian', 'Pesketarian'].sample
    user.password = 'passpass'
    user.confirmed_at = Time.zone.now
    user.member_at = Time.zone.now
    user.save!
    user
  end

  def add_to_group(group, user, fadder: false)
    GroupUser.find_or_create_by!(group: group, user: user, fadder: fadder)
  end
end
