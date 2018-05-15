namespace :db do
  desc 'Loads some stuff into the database for local testing'
  task(populate_test: :environment) do
    # Councils
    pryl = Council.find_or_create_by!(title: 'Prylmästeriet',
                                      url: 'pryl', description: 'Detta är Prylmästeriet')

    sexm = Council.find_or_create_by!(title: 'Sexmästeriet',
                                      url: 'sex', description: 'Detta är Sexmästeriet')
    cafem = Council.find_or_create_by!(title: 'Cafemästeriet',
                                       url: 'cafe', description: 'Detta är Cafemästeriet')
    # Posts
    # Prylmästeriet
    spindel = Post.find_or_create_by!(title: 'Spindelman', limit: 0, rec_limit: 10, description: 'En administratör',
                                      council: pryl, elected_by: Post::BOARD, semester: Post::SPRING, car_rent: true)

    prylmast = Post.find_or_create_by!(title: 'Prylmästare', limit: 1, rec_limit: 1,
                                       description: 'Prylmästarn', council: pryl, elected_by: Post::GENERAL,
                                       board: true, semester: Post::SPRING, car_rent: true)
    # Sexmästeriet

    sexmast = Post.find_or_create_by!(title: 'Sexmästare', limit: 1, rec_limit: 1,
                                      description: 'Sexmästaren', council: sexm, elected_by: Post::GENERAL,
                                      board: true, semester: Post::SPRING, car_rent: true)

    # Cafemästeriet
    Post.find_or_create_by!(title: 'Vice cafemästare', limit: 1, rec_limit: 1, description: 'En vice cm',
                            council: cafem, elected_by: Post::GENERAL,
                            board: true, semester: Post::AUTUMN, car_rent: true)

    cafemast = Post.find_or_create_by!(title: 'Cafemästare', limit: 1, rec_limit: 1,
                                       description: 'Cafemästaren', council: cafem, elected_by: Post::GENERAL,
                                       board: true, semester: Post::AUTUMN, car_rent: true)

    nyckelpiga = Post.find_or_create_by!(title: 'Nyckelpiga', limit: 0, rec_limit: 10,
                                         description: 'Nyckelpigan!', council: cafem, elected_by: Post::BOARD, semester: Post::BOTH)

    # Set president!
    pryl.update(president: prylmast)
    sexm.update(president: sexmast)
    cafem.update(president: cafemast)

    # Permissions
    Rake::Task['permissions:load'].invoke
    perm_admin = Permission.find_or_create_by!(subject_class: :all, action: :manage)
    perm_nyckelpiga = Permission.find_or_create_by!(subject_class: 'CafeWork', action: :nyckelpiga)
    # Give spindelman admin
    PermissionPost.find_or_create_by!(permission: perm_admin, post: spindel)
    PermissionPost.find_or_create_by!(permission: perm_nyckelpiga, post: nyckelpiga)

    admin = User.find_or_initialize_by(email: 'admin@fsektionen.se',
                                       firstname: 'Hilbert-Admin', lastname: 'Älg',
                                       program: 'Teknisk Fysik', start_year: 1996)
    admin.password = 'passpass'
    admin.password_confirmation = 'passpass'
    admin.confirmed_at = Time.zone.now
    admin.member_at = Time.zone.now
    admin.save!
    puts 'You can sign in as ADMIN with'
    puts 'email:        admin@fsektionen.se'
    puts 'and password: passpass'
    if admin.present?
      PostUser.find_or_create_by(post: spindel, user: admin)
      PostUser.find_or_create_by(post: prylmast, user: admin)
      PostUser.find_or_create_by(post: cafemast, user: admin)
      PostUser.find_or_create_by(post: sexmast, user: admin)
    end

    user = User.find_or_initialize_by(email: 'user@fsektionen.se',
                                      firstname: 'Hilbert', lastname: 'Älg',
                                      program: 'Teknisk Fysik', start_year: 1996)
    user.confirmed_at = Time.zone.now
    user.member_at = Time.zone.now
    user.password = 'passpass'
    user.password_confirmation = 'passpass'
    user.save!

    puts 'You can sign in as USER with'
    puts 'email:        user@fsektionen.se'
    puts 'and password: passpass'
    if user.present?
      PostUser.find_or_create_by(post: prylmast, user: user)
    end

    # Election
    election = Election.find_or_initialize_by(title: 'Vårterminsmöte',
                                              url: 'vt-15',
                                              visible: true,
                                              semester: Post::SPRING)
    election.update!(open: 2.days.ago,
                     close_general: 5.days.from_now,
                     close_all: 10.days.from_now)

    # Contact
    Contact.find_or_create_by(name: 'Spindelman', email: 'spindelman@fsektionen.se',
                              public: true, text: 'Detta är en liten spindelman', post: spindel)

    # News
    News.find_or_create_by!(title: 'Ett helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: admin)
    News.find_or_create_by!(title: 'Andra helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: admin)
    News.find_or_create_by!(title: 'Tredje helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: admin)
    News.find_or_create_by!(title: 'Fjärde helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: admin)
    News.find_or_create_by!(title: 'Femte helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: admin)
    # Events
    date = Time.zone.now.middle_of_day
    (1..10).each do |i|
      event = Event.create!(short_sv: %(E#{i}), title_sv: %(Evenemang #{i}),
                            title_en: %(Event #{i}), description_sv: 'Detta kommer bli ett evenemang!',
                            description_en: 'This will be an event!',
                            starts_at: date, ends_at: date + 5.hours,
                            food: true, drink: true, location: 'Gasquesalen')
      event.update!(short_en: event.short)
      date = date + 1.days + [-3,-2,-1,0,1,2,3].sample.hours
    end

    # Gallery
    Album.find_or_create_by!(title: 'Välkomstgasque', description: 'Väldans trevligt!', location: 'Gasquesalen',
                             start_date: Time.zone.now, category: 'Nollning', end_date: Time.zone.now + 10.hours)

    # Documents
    FactoryBot.create(:document)
    FactoryBot.create(:document)

    # Categories
    Category.find_or_create_by!(title: 'Studier', slug: 'studie')
    Category.find_or_create_by!(title: 'Sektionen', slug: 'sektion')
    Category.find_or_create_by!(title: 'Fritid', slug: 'fritid')
    Category.find_or_create_by!(title: 'Nollning', slug: 'nollning')

    #Tool
    tool = Tool.find_or_create_by!(title: 'Hammare', description: 'spikar spikar m.m.', total: 5)
    # Tool Renting
    ToolRenting.find_or_create_by!(renter: 'adrian', tool: tool, purpose: 'for home use', return_date: Time.zone.now)
    ToolRenting.find_or_create_by!(renter: 'adrian2', tool: tool, purpose: 'for other use', return_date: Time.zone.now)

    # Introduction
    introduction = Introduction.find_or_create_by!(title: 'En Ridderlig Nollning',
                                                   start: Time.zone.now.change(month: 8, day: 22).beginning_of_day,
                                                   stop: Time.zone.now.change(month: 9, day: 20).end_of_day,
                                                   slug: :ridderlig, current: true)

    group = Group.find_or_create_by!(group_type: Group::REGULAR, name: 'Black Knight', number: 1, introduction: introduction)
    GroupUser.find_or_create_by!(group: group, user: user, fadder: true)

    # Songs
    Song.find_or_create_by!(title: 'Hello World',
                            author: 'Edwin',
                            category: 'Absurda Visor',
                            content: 'Det var en gång en liten Värld som utplånades! Skål!')

    Song.find_or_create_by!(title: 'Hello Sweden',
                            author: 'Gurra',
                            category: 'Visor',
                            content: 'Sverige är Sverige och Sverige är bra!')

    # Notifications
    Rpush::Gcm::App.find_or_create_by!(name: :firebase, auth_key: :test)
  end
end
