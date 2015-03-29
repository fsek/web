namespace :load_database do
  desc 'Loads some stuff into the database for local testing'
  task(populate: :environment) do
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
    Post.find_or_create_by!(title: 'Server', limit: 0, recLimit: 10, description: 'En serverare',
                            council: sexm, elected_by: 'Styrelsen', elected_at: 'HT')

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
    perm_nyckelpiga = Permission.find_or_create_by!(subject_class: :cafe_work, action: :nyckelpiga)
    # Give spindelman admin
    PermissionPost.find_or_create_by!(permission: perm_admin, post: spindel)
    PermissionPost.find_or_create_by!(permission: perm_nyckelpiga, post: nyckelpiga)

    u = User.find_or_initialize_by(username: 'user', email: 'david@da.vid')
    u.password = 'passpass'
    u.as_f_member.save!
    if u.present?
      p = u.profile
      p.update!(name: 'David', lastname: 'Wessman', program: 'Teknisk Fysik', start_year: 2013)
      if !p.posts.include?(spindel)
        p.posts << spindel
      end
      if !p.posts.include?(prylmast)
        p.posts << prylmast
      end
      if !p.posts.include?(cafemast)
        p.posts << cafemast
      end
      if !p.posts.include?(sexmast)
        p.posts << sexmast
      end
    end

    # Menues
    Menu.find_or_create_by!(location: 'Sektionen', name: 'Om oss',
                            link: '/om', index: 10, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: 'Sektionen', name: 'Utskott',
                            link: '/utskott', index: 20, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: 'Sektionen', name: 'Dokument',
                            link: '/dokument', index: 30, visible: true, turbolinks: true)

    Menu.find_or_create_by!(location: 'För medlemmar', name: 'Val',
                            link: '/val', index: 10, visible: true, turbolinks: true)
    Menu.find_or_create_by!(location: 'För medlemmar', name: 'Bilbokning',
                            link: '/bil', index: 20, visible: true, turbolinks: false)
    Menu.find_or_create_by!(location: 'För medlemmar', name: 'Hilbertcafé',
                            link: '/hilbertcafe', index: 30, visible: true, turbolinks: false)
  end
end
