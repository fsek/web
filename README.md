[![Code Climate](https://codeclimate.com/github/fsek/web/badges/gpa.svg)](https://codeclimate.com/github/fsek/web) [![Test Coverage](https://codeclimate.com/github/fsek/web/badges/coverage.svg)](https://codeclimate.com/github/fsek/web) [![Build Status](https://travis-ci.org/fsek/web.svg?branch=master)](https://travis-ci.org/fsek/web)

Detta finns:
============
- Användarsystem, profiler och auktorisering
- Bilbokning
- Dynamiska utskott som har poster
- Kontaktformulär 
- Nyheter
- Layout
- En storage-mapp där vi placerar bilder, dokument


Generella layoutsaker:
======================
Lite kunskap om rails layouts
  Rails bygger ihop css och js filer genom /app/assets/stylesheets/application.css resp. /app/assets/javascripts/application.js.
  Där tar den och samlar ihop css-filer resp. js-filer från en massa olika källor:
    - Lokala css-/js-filer för varje view och för huvudlayouten ligger under
        /app/assets/javascript eller stylesheets
    - Plugin som sparas lokalt på servern ligger under
        /vendor/assets
        t.ex. bootstrap, hover-dropdown.js, back-to-top.js
    - Plugin som installers som gem finns i Gemfilen (dessa ligger också lokalt på datorn fast utanför rails-applikationen)
        t.ex. jQuery, FontAwesome, Breadcrumbs

  Bilder sparas i /app/assets/images och koms åt i applikationen genom att anropa
    <%= image_tag "name.jpg", class: "enklass" %>


Vill man ha en ikon 
  - gå in på http://fortawesome.github.io/Font-Awesome/icons/ och hitta den du vill ha
  - skapa ikonen genom att anropa
      icon("namnetpåikonen") #utan 'fa-' prefixet
  - i den köpta layouten förkomemr ibland klassen 'icon-myicon', den behöver bytas ut mot 'fa fa-myicon', pga versionsbyte

Vill man komma åt den inloggade användaren anropar man
  current_user() #du måste inte ha paranteser

Vill man kolla om använaren är inloggad anropar man
  <% if user_signed_in? %>
    DO STUFF
  <% end %>

Eftersom vi kör lite olika versioner av diverse plugins/bootstrap kan den köpta layouten strula lite ibland, då får man småpilla! :)




Skapa nya controllers
=====================
Tag news_controller som exempel.

Breadcrumbs:
  Hem/Nyheter/Redigera (dvs strängen under menyn som visar var på sidan man befinner sig.

  Lämpligen lägger man till
    add_breadcrumbs "Nyheter", :news_index_path
  högst upp i controllern någonstans. Därefter lägger man (om man vill) till typ
    add_breadcrumbs "Redigera", nil
  inne i en action om man vill specificera breadcrumben mer


Vill man komma åt den inloggade användaren anropar man
  current_user() #du måste inte ha paranteser

Vill man kolla om använaren är inloggad anropar man
  <% if user_signed_in? %>
    DO STUFF
  <% end %>





Skapa nya views
===============
Lägg till 
  <% title("MinSida") %> 
någonstans i en view för att få titeln på sidan under F-sektionsloggan.

Lägg till
  <% content_for(:sidebar) do %>
    COOLA SAKER
  <% end %>
någonstans i en view för att få content specifikt för just den sidan/viewen.



Minnasanteckningar om knep som körts för att få det att installera:
===================================================================
Run the follow commands (do they need to be run for each new setup?)
bundle install
rake assets:precompile RAILS_ENV=development
rake db:create
rake db:migrate

git add -A
git commit -m "Ditt commit meddelande"
git push origin master
