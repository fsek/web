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
    # Positions
    # Prylmästeriet
    spindel = Position.find_or_create_by!(title: 'Spindelman', limit: 0, rec_limit: 10, description: 'En administratör',
                                      council: pryl, elected_by: Position::BOARD, semester: Position::SPRING, car_rent: true)

    prylmast = Position.find_or_create_by!(title: 'Prylmästare', limit: 1, rec_limit: 1,
                                       description: 'Prylmästarn', council: pryl, elected_by: Position::GENERAL,
                                       board: true, semester: Position::SPRING, car_rent: true)
    # Sexmästeriet

    sexmast = Position.find_or_create_by!(title: 'Sexmästare', limit: 1, rec_limit: 1,
                                      description: 'Sexmästaren', council: sexm, elected_by: Position::GENERAL,
                                      board: true, semester: Position::SPRING, car_rent: true)

    # Cafemästeriet
    Position.find_or_create_by!(title: 'Vice cafemästare', limit: 1, rec_limit: 1, description: 'En vice cm',
                            council: cafem, elected_by: Position::GENERAL,
                            board: true, semester: Position::AUTUMN, car_rent: true)

    cafemast = Position.find_or_create_by!(title: 'Cafemästare', limit: 1, rec_limit: 1,
                                       description: 'Cafemästaren', council: cafem, elected_by: Position::GENERAL,
                                       board: true, semester: Position::AUTUMN, car_rent: true)

    nyckelpiga = Position.find_or_create_by!(title: 'Nyckelpiga', limit: 0, rec_limit: 10,
                                         description: 'Nyckelpigan!', council: cafem, elected_by: Position::BOARD, semester: Position::BOTH)

    # Set president!
    pryl.update(president: prylmast)
    sexm.update(president: sexmast)
    cafem.update(president: cafemast)

    # Permissions
    Rake::Task['permissions:load'].invoke
    perm_admin = Permission.find_or_create_by!(subject_class: :all, action: :manage)
    perm_nyckelpiga = Permission.find_or_create_by!(subject_class: 'CafeWork', action: :nyckelpiga)
    # Give spindelman admin
    PermissionPosition.find_or_create_by!(permission: perm_admin, position: spindel)
    PermissionPosition.find_or_create_by!(permission: perm_nyckelpiga, position: nyckelpiga)

    admin = User.find_or_initialize_by(email: 'admin@fsektionen.se',
                                       firstname: 'Hilbert-Admin', lastname: 'Älg',
                                       program: 'Teknisk Fysik', start_year: 1996)
    admin.password = 'passpass'
    admin.confirmed_at = Time.zone.now
    admin.member_at = Time.zone.now
    admin.save!
    puts 'You can sign in as ADMIN with'
    puts 'email:        admin@fsektionen.se'
    puts 'and password: passpass'
    if admin.present?
      PositionUser.find_or_create_by(position: spindel, user: admin)
      PositionUser.find_or_create_by(position: prylmast, user: admin)
      PositionUser.find_or_create_by(position: cafemast, user: admin)
      PositionUser.find_or_create_by(position: sexmast, user: admin)
    end

    user = User.find_or_initialize_by(email: 'user@fsektionen.se',
                                      firstname: 'Hilbert', lastname: 'Älg',
                                      program: 'Teknisk Fysik', start_year: 1996)
    user.confirmed_at = Time.zone.now
    user.member_at = Time.zone.now
    user.password = 'passpass'
    user.save!

    puts 'You can sign in as USER with'
    puts 'email:        user@fsektionen.se'
    puts 'and password: passpass'
    if user.present?
      PositionUser.find_or_create_by(position: prylmast, user: user)
    end

    # Main menus
    sekt = MainMenu.find_or_create_by!(name: 'Sektionen', index: 10, mega: false)
    sekt.update(name_en: 'Guild')
    medl = MainMenu.find_or_create_by!(name: 'För medlemmar', index: 20, mega: true)

    menu = Menu.find_or_create_by!(main_menu: sekt, name: 'Om oss',
                            link: '/om', index: 10, visible: true, turbolinks: true)
    menu.update!(name_en: 'About us')

    menu = Menu.find_or_create_by!(main_menu: sekt, name: 'Utskott',
                            link: '/utskott', index: 20, visible: true, turbolinks: true)
    menu.update!(name_en: 'Councils')

    menu = Menu.find_or_create_by!(main_menu: sekt, name: 'Dokument',
                            link: '/dokument', index: 30, visible: true, turbolinks: true)
    menu.update!(name_en: 'Documents')

    menu = Menu.find_or_create_by!(main_menu: medl, name: 'För medlemmar',
                            link: '#', index: 1, visible: true, turbolinks: true, header: true)
    menu.update!(name_en: 'For members')

    menu = Menu.find_or_create_by!(main_menu: medl, name: 'Val',
                            link: '/val', index: 10, visible: true, turbolinks: true)
    menu.update!(name_en: 'Election')

    menu = Menu.find_or_create_by!(main_menu: medl, name: 'Bilbokning',
                            link: '/bilbokning', index: 20, visible: true, turbolinks: false)
    menu.update!(name_en: 'Car rental')

    menu = Menu.find_or_create_by!(main_menu: medl, name: 'Hilbertcafé',
                            link: '/hilbertcafe', index: 30, visible: true, turbolinks: false)
    menu.update!(name_en: 'Hilbert Café')

    menu = Menu.find_or_create_by!(main_menu: medl, name: 'Bildgalleri',
                            link: '/galleri', index: 40, visible: true, turbolinks: false)
    menu.update!(name_en: 'Image gallery')

    # Notice
    FactoryGirl.create(:notice, user: admin)
    FactoryGirl.create(:notice, user: admin)

    # Election
    election = Election.find_or_initialize_by(title: 'Vårterminsmöte',
                                              url: 'vt-15',
                                              visible: true,
                                              semester: Position::SPRING)
    election.update!(open: 2.days.ago,
                     close_general: 5.days.from_now,
                     close_all: 10.days.from_now)

    # Contact
    Contact.find_or_create_by(name: 'Spindelman', email: 'spindelman@fsektionen.se',
                              public: true, text: 'Detta är en linte spindelman', position: spindel)

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
      event = Event.find_or_create_by!(short: %(E#{i}), title: %(Evenemang #{i}),
                                       description: 'Detta kommer bli ett evenemang!',
                                       starts_at: date, ends_at: date + 5.hours,
                                       food: true, drink: true, location: 'Gasquesalen')
      event.update!(short_en: event.short, title_en: %(Event #{i}), description_en: 'This will be an event!')
      date = date + 1.days + [-3,-2,-1,0,1,2,3].sample.hours
    end

    # Gallery
    Album.find_or_create_by!(title: 'Välkomstgasque', description: 'Väldans trevligt!', location: 'Gasquesalen',
                             start_date: Time.zone.now, category: 'Nollning', end_date: Time.zone.now + 10.hours)

    # Documents
    FactoryGirl.create(:document)
    FactoryGirl.create(:document)

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
    introduction = Introduction.find_or_create_by!(title: 'En Ridderlig Nollning', start: 10.days.from_now, stop: 37.days.from_now,
                                                   slug: :ridderlig, current: true)

    group = Group.find_or_create_by!(group_type: Group::REGULAR, name: 'Black Knight', number: 1, introduction: introduction)
    GroupUser.find_or_create_by!(group: group, user: user, fadder: true)
  end
end
