[![Code Climate](https://codeclimate.com/github/fsek/web/badges/gpa.svg)](https://codeclimate.com/github/fsek/web) [![Test Coverage](https://codeclimate.com/github/fsek/web/badges/coverage.svg)](https://codeclimate.com/github/fsek/web) [![Build Status](https://travis-ci.org/fsek/web.svg?branch=master)](https://travis-ci.org/fsek/web) [![Dependency Status](https://gemnasium.com/fsek/web.svg)](https://gemnasium.com/fsek/web) [![security](https://hakiri.io/github/fsek/web/master.svg)](https://hakiri.io/github/fsek/web/master)

Server versions:
[![Production](http://samson.fsektionen.se/projects/web/stages/production.svg?token=8d70d6eaf8ef80c828d2f1472e89dc6d)](http://samson.fsektionen.se/projects/web/stages/production)
[![Dev](http://samson.fsektionen.se/projects/web/stages/dev.svg?token=8d70d6eaf8ef80c828d2f1472e89dc6d)](http://samson.fsektionen.se/projects/web/stages/dev)

[![Join the chat at https://gitter.im/fsek/web](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/fsek/web?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


Hur man gör saker
================

Jag vill skriva kod
-------------------
1. git checkout master.
2. git checkout -b minfetabransch.
3. Gör dina ändringar och committa dem.
4. Under tiden kan det ha hänt saker med master. Då behöver du rebasea (inte
   merga) din bransch på master med git rebase origin/master.
5. Kontrollera så att din commitlog består av vettiga och logiska patchar. Slå
   ihop små plottriga committar med git rebase -i. Dela upp committar som
   handlar om mer en än sak med git add -p.
6. Läs igenom din patch (git diff master).
7. Läs den en gång till.
8. git push --set-upstream origin minfetabransch
9. In på github och skapa en pullrequest.
10. Vänta några dagar på kommentarer, se vad hounden har att säga och fixa det
    om det låter vettigt.
11. Upprepa (5-7)
12. Merga till master och pusha upp. Deploy ska ske automagiskt.

[dev.fsektionen.se](http://dev.fsektionen.se)
- Följer dev-branchen och kör mot prod databasen
- Här kan ni merga in era brancher och testa dem
- Var försiktiga så ni inte sabbar prod-databasen

__Vad man inte ska göra:__
- Ändra filer direkt på servern. Det kan förstöra konfigurationerna (speciellt om detta görs som root).
- Force-pusha till master
- Commita direkt på master-branchen.

Om det inte funkar:
- Synka most github manuellt (kräver att du är admin): [master](http://fsektionen.se/githook/master) [dev](http://fsektionen.se/githook/dev)

Jag vill ha en bransch
----------------------

Kalla branschen för dittnamn/vadduvillgöra så ser alla att du äger den. Då kan
du force-pusha till den osv., det är ju din bransch.

Om du behöver integrera flera ändringar tillsammans så är det enklast att
använda en egen integrationsbransch. Den får man förstås inte force-pusha till.
Det är enklast att undvika detta om man inte verkligen måste.

Specialbranscher som har egna gitkrokar

* master: motsvarar den version av koden som körs i produktion. 
  * Var rädd om master, i regel vill vi se pull requests innan merge
  * Deployas automatiskt till fsektionen.se mha. gitkrokar. 
* stage: en testversion som körs live på servern
  * Denna branschen är ok att klubba om det behövs
  * Deployas automatiskt till stage.fsektionen.se mha. gitkrokar
* dev: en annan testversion
  * Denna branschen är ok att klubba om det behövs
  * Deployas automatiskt till dev.fsektionen.se mha. gitkrokar

Jag vill ha lite fräsch testdata i min lokala databas
-----------------------------------------------------

Enklast är att dumpa produktionsdatabasen och ladda in den lokalt. ssha till
dirac och använd mysqldump för att få ut en fil med all data i.

På dirac:

mysqldump db/fsek_production -u root -p > mindatabas.sql

Lokalt:

scp fsektionen.se:mindatabas.sql .

mysql fsek_development -u root -p < mindatabas.sql

rake db:migrate


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

