# Main Menus
guild = MainMenu.create!(index: 10, mega: true, fw: true,
                         name_sv: 'Sektionen', name_en: 'The Guild')
members = MainMenu.create!(index: 20, mega: true, fw: false,
                           name_sv: 'För medlemmar', name_en: 'For Members')
nollning = MainMenu.create!(index: 30, mega: false, fw: false,
                            name_sv: 'Nollning', name_en: 'Nollning')

# Guild Menu
Menu.create!(main_menu: guild, column: 1, index: 10, header: true,
             name_sv: 'Allmänt', name_en: 'General', link: '#')
Menu.create!(main_menu: guild, column: 1, index: 20,
             name_sv: 'Om oss', name_en: 'About us', link: '/om')
Menu.create!(main_menu: guild, column: 1, index: 30,
             name_sv: 'Utskott', name_en: 'Committees', link: '/utskott')
Menu.create!(main_menu: guild, column: 1, index: 40,
             name_sv: 'Dokument', name_en: 'Documents', link: '/dokument')
Menu.create!(main_menu: guild, column: 1, index: 50,
             name_sv: 'Blogg', name_en: 'Blog', link: '/blogg')

Menu.create!(main_menu: guild, column: 2, index: 10, header: true,
             name_sv: 'För företag', name_en: 'For Companies', link: '#')
Menu.create!(main_menu: guild, column: 2, index: 20,
             name_sv: 'Om F-Sektionen', name_en: 'About F-Sektionen', link: '/foretag/om')
Menu.create!(main_menu: guild, column: 2, index: 30,
             name_sv: 'Vi erbjuder', name_en: 'We Offer', link: '/foretag/vi-erbjuder')
Menu.create!(main_menu: guild, column: 2, index: 40,
             name_sv: 'Kontakt', name_en: 'Contact', link: '/kontakter/4')
Menu.create!(main_menu: guild, column: 2, index: 40, blank_p: true,
             name_sv: 'Farad', name_en: 'Farad', link: 'http://farad.nu')

Menu.create!(main_menu: guild, column: 3, index: 10, header: true,
             name_sv: 'Kontakt', name_en: 'Contact', link: '#')
Menu.create!(main_menu: guild, column: 3, index: 20,
             name_sv: 'Kontaktsida', name_en: 'Contact Page', link: '/kontakter')
Menu.create!(main_menu: guild, column: 3, index: 30,
             name_sv: 'Ordförande', name_en: 'Chairman', link: '/kontakter/19')
Menu.create!(main_menu: guild, column: 3, index: 40,
             name_sv: 'Webbansvarig', name_en: 'Webmaster', link: '/kontakter/1')

Menu.create!(main_menu: guild, column: 4, index: 10, header: true,
             name_sv: 'Feedback', name_en: 'Feedback', link: '#')
Menu.create!(main_menu: guild, column: 4, index: 20, blank_p: true,
             name_sv: 'Tyck till', name_en: 'Leave Feedback',
             link: 'https://fsektionen.typeform.com/to/a9Mmq9')
Menu.create!(main_menu: guild, column: 4, index: 30, blank_p: true,
             name_sv: 'Felrapport', name_en: 'Report a Bug',
             link: 'https://davidwesmn.typeform.com/to/WiWWNn')

# Members menu
Menu.create!(main_menu: members, column: 1, index: 10, header: true,
             name_sv: 'Engagera dig', name_en: 'Get engaged', link: '#')
Menu.create!(main_menu: members, column: 1, index: 20,
             name_sv: 'Val', name_en: 'Election', link: '/val')
Menu.create!(main_menu: members, column: 1, index: 30,
             name_sv: 'Hilbert Café', name_en: 'Hilbert Café', link: '/hilbertcafe')
Menu.create!(main_menu: members, column: 1, index: 40,
             name_sv: 'Motionsmaskin', name_en: 'Motion Generator', link: '/proposals/form')

Menu.create!(main_menu: members, column: 2, index: 10, header: true,
             name_sv: 'Tjänster', name_en: 'Services', link: '#')
Menu.create!(main_menu: members, column: 2, index: 20,
             name_sv: 'Bildgalleri', name_en: 'Picture Gallery', link: '/galleri')
Menu.create!(main_menu: members, column: 2, index: 30,
             name_sv: 'Bilbokning', name_en: 'Car Rental', link: '/bilbokning')
Menu.create!(main_menu: members, column: 2, index: 40,
             name_sv: 'Verktyg', name_en: 'Tools', link: '/verktyg')
Menu.create!(main_menu: members, column: 2, index: 50,
             name_sv: 'Sångbok', name_en: 'Song Book', link: '/sangbok')

Menu.create!(main_menu: members, column: 3, index: 10, header: true,
             name_sv: 'Övrigt', name_en: 'Other', link: '#')
Menu.create!(main_menu: members, column: 3, index: 20,
             name_sv: 'Kalender', name_en: 'Calendar', link: '/kalender')
Menu.create!(main_menu: members, column: 3, index: 30,
             name_sv: 'Likabehandling', name_en: 'Student Equality', link: '/utskott/libu')
Menu.create!(main_menu: members, column: 3, index: 40,
             name_sv: 'Lokalbokning', name_en: 'Facility Reservations', link: '/lokalbokning')

# Nollning menu
Menu.create!(main_menu: nollning, index: 10, name_sv: 'Nollning 2016',
             name_en: 'Nollning 2016', link: '/nollning')
