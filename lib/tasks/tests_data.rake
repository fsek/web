namespace :db do
  desc 'Loads some stuff into the database for local testing'
  task(populate_test: :environment) do
    # Councils
    pryl = Council.find_or_create_by!(title: 'Prylmästeriet',
                                      url: 'pryl', description: 'Detta är Prylmästeriet', public: true)

    sexm = Council.find_or_create_by!(title: 'Sexmästeriet',
                                      url: 'sex', description: 'Detta är Sexmästeriet', public: true)
    cafem = Council.find_or_create_by!(title: 'Cafemästeriet',
                                       url: 'cafe', description: 'Detta är Cafemästeriet', public: true)

    # Posts
    # Prylmästeriet
    spindel = Post.find_or_create_by!(title: 'Spindelman', limit: 0, recLimit: 10, description: 'En administratör',
                                      council: pryl, elected_by: 'Styrelsen', elected_at: 'VT', car_rent: true)

    prylmast = Post.find_or_create_by!(title: 'Prylmästare', limit: 1, recLimit: 1,
                                       description: 'Prylmästarn', council: pryl, elected_by: 'Terminsmötet',
                                       styrelse: true, elected_at: 'VT', car_rent: true)
    # Sexmästeriet

    sexmast = Post.find_or_create_by!(title: 'Sexmästare', limit: 1, recLimit: 1,
                                      description: 'Sexmästaren', council: sexm, elected_by: 'Terminsmötet',
                                      styrelse: true, elected_at: 'VT', car_rent: true)

    # Cafemästeriet
    Post.find_or_create_by!(title: 'Vice cafemästare', limit: 1, recLimit: 1, description: 'En vice cm',
                            council: cafem, elected_by: 'Terminsmötet',
                            styrelse: true, elected_at: 'HT', car_rent: true)

    cafemast = Post.find_or_create_by!(title: 'Cafemästare', limit: 1, recLimit: 1,
                                       description: 'Cafemästaren', council: cafem, elected_by: 'Terminsmötet',
                                       styrelse: true, elected_at: 'HT', car_rent: true)
    nyckelpiga = Post.find_or_create_by!(title: 'Nyckelpiga', limit: 0, recLimit: 10,
                                         description: 'Nyckelpigan!', council: cafem, elected_by: '')

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

    u = User.find_or_initialize_by(email: 'admin@fsektionen.se',
                                   firstname: 'David-Admin', lastname: 'Wessman',
                                   program: 'Teknisk Fysik', start_year: 2013)
    u.password = 'passpass'
    u.confirmed_at = Time.zone.now
    u.member_at = Time.zone.now
    u.save!
    if u.present?
      PostUser.find_or_create_by(post: spindel, user: u)
      PostUser.find_or_create_by(post: prylmast, user: u)
      PostUser.find_or_create_by(post: cafemast, user: u)
      PostUser.find_or_create_by(post: sexmast, user: u)
    end

    a = User.find_or_initialize_by(email: 'user@fsektionen.se',
                                   firstname: 'David', lastname: 'Wessman',
                                   program: 'Teknisk Fysik', start_year: 2013)
    a.confirmed_at = Time.zone.now
    a.member_at = Time.zone.now
    a.password = 'passpass'
    a.save!
    if a.present?
      PostUser.find_or_create_by(post: prylmast, user: a)
    end

    # Menues
    Menu.find_or_create_by!(location: :guild, name: 'Om oss',
                            link: '/om', index: 10, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: :guild, name: 'Utskott',
                            link: '/utskott', index: 20, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: :guild, name: 'Dokument',
                            link: '/dokument', index: 30, visible: true, turbolinks: true)

    Menu.find_or_create_by!(location: :members, name: 'Val',
                            link: '/val', index: 10, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: :members, name: 'Bilbokning',
                            link: '/bilbokning', index: 20, visible: true, turbolinks: false)
    Menu.find_or_create_by!(location: :members, name: 'Hilbertcafé',
                            link: '/hilbertcafe', index: 30, visible: true, turbolinks: false)
    Menu.find_or_create_by!(location: :members, name: 'Bildgalleri',
                            link: '/galleri', index: 40, visible: true, turbolinks: false)

    # Notice
    Notice.find_or_create_by!(FactoryGirl.attributes_for(:notice))
    Notice.find_or_create_by!(FactoryGirl.attributes_for(:notice))

    # Election
    election = Election.find_or_initialize_by(title: 'Vårterminsmöte',
                                              url: 'vt-15', visible: true )
    election.update!(start: Time.zone.now - 2.days,
                     end: Time.zone.now + 5.days)
    Post.all do |posten|
      election.posts << posten
    end
    election.save!

    # Contact
    Contact.find_or_create_by(name: 'Spindelman - David', email: 'spindelman@fsektionen.se',
                              public: true, text: 'Detta är en linte spindelman',
                              council_id: Council.first.try(:id))

    # News
    News.find_or_create_by!(title: 'Ett helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Andra helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Tredje helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Fjärde helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    News.find_or_create_by!(title: 'Femte helt nytt användarsystem',
                            content: 'Nu har vi en himla massa roliga funktioner som blir mycket lättare att lägga in, det är ju <br>toppen.',
                            user: User.first)
    # Events
    date = Time.zone.now.middle_of_day
    (1..10).each do |i|
      Event.find_or_create_by!(short: %(E#{i}), title: %(Event#{i}), starts_at: date, ends_at: date + 5.hours,
                               description: "beskrivningen", food: true, drink: true)
      date = date + 1.days + [-3,-2,-1,0,1,2,3].sample.hours
    end

    # Gallery
    Album.find_or_create_by!(title: 'Välkomstgasque', description: 'Väldans trevligt!', location: 'Gasquesalen',
                             start_date: Time.zone.now, category: 'Nollning', end_date: Time.zone.now + 10.hours)

    # Documents
    FactoryGirl.create(:document)
    FactoryGirl.create(:document)
  end
end
