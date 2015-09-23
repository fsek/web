[![Code Climate](https://codeclimate.com/github/fsek/web/badges/gpa.svg)](https://codeclimate.com/github/fsek/web)
[![Test Coverage](https://codeclimate.com/github/fsek/web/badges/coverage.svg)](https://codeclimate.com/github/fsek/web)
[![Dependency Status](https://gemnasium.com/fsek/web.svg)](https://gemnasium.com/fsek/web)
[![security](https://hakiri.io/github/fsek/web/master.svg)](https://hakiri.io/github/fsek/web/master)

[Master](https://fsektionen.se)

[![CircleCI](https://circleci.com/gh/fsek/web/tree/master.svg?style=shield&circle-token=:circle-ci-badge-token)](https://circleci.com/gh/fsek/web/tree/master)

[Stage](http://stage.fsektionen.se)

[![CircleCI](https://circleci.com/gh/fsek/web/tree/stage.svg?style=shield&circle-token=:circle-ci-badge-token)](https://circleci.com/gh/fsek/web/tree/stage)


How to do stuff
================

I wanna write code
-------------------
1. `git checkout master`
2. `git checkout -b mycoolfeature`.
3. Make your changes and commit them
4. While working on your branch, there might have been changes at the master
branch. This calls for a **rebase** (do not do merges for this).
You call `git rebase origin master`.
5. Control your `git log` to make sure that your commits are sane and logical.
Incase of messy Hound fixes and similar, wrap them up with `git rebase -i`. If
you have a lot of changes which doesn't belong in the same commit, you can use
`git add -p` to split it into logical commits.
6. Read through your path, check `git diff master`
7. (round == 1) ? Repeat 6 : Continue;
8. `git push --set-upstream origin mycoolfeature`
9. Go into Github and submit a pull request.
10. Let the team comment, become friends with the Hound and solve code style
errors which makes sense.
11. If you done changes - repeat step 5-7
12. Merge your branch to master, deploy should follow

---------------------

__[stage.fsektionen.se](http://stage.fsektionen.se)__
- Follows the `stage`-branch and running on a separate database
- Is okay to merge and force push and to use as a crash course.


__[fsektionen.se](https://fsektionen.se)__
- Follows the `master`-branch and running on the production database

__What you should never do:__
- Change files directly on the server (especially running commands as root!)
- Force-push to master
- Create commits directly on master

I want my own branch!
----------------------

Call the branch something with your `ownname-feature` or `ownname/feature`.

This shows that this is your branch, you can do whatever force-pushes and equal.

If you want to integrate many features at ones, make pull-requests to a separate
branch which you can then merge into master.

I want some fresh data for my database!
-----------------------------------------------------

For a smaller setup you can use the rake-task:
`rake db:populate_test`.

If you are adding new features which should be in this database you edit the
file in `lib/tasks`.

----------------------

If you want a complete set you can dump the production database from the server
and use it locally.

On the server:

`mysqldump db/fsek_production -u root -p > mydatabase.sql`

Locally:

`scp fsektionen.se:mydatabase.sql .`

`mysql fsek_development -u root -p < mindatabas.sql`

rake db:migrate


Layout things:
======================
For compiling our stylesheets and javascript files there are two main files.

For **CSS** there is `app/assets/stylesheets/application.scss` where the needed
CSS is added with `@import`-tags.

All css located in the `stylesheets/style` folder holds our theme laying over
our Bootstrap.

All css located in the `stylesheets/partials` is our own written scss files,
split on controller or function.

All files in these folders will be loaded.

For **Javascript** we have the same setup but using Sprockets.
This is seen in `app/assets/javascripts/application.js`.

All the local files go into these folders.


Files from Vendors, such ass from plugins or gems are placed in `vendor/assets`.

Files that are not from vendors but not project specific goes into `lib/assets`.

Images which are used in layouts and similar should be placed in:
`app/assets/images`.

An image in this folder called `image.jpg` can be referenced with:

`<%= image_tag('image.jpg') %>`

If you are looking for **icons**:
- visit [FontAwesome](https://fortawesome.github.io/Font-Awesome/icons/) and
  find your icon
- Use the helper method to call it: `fa_icon('user')`.


Creating new controllers
=====================

For example `news_controller`:

To use our authentication system Cancancan you need to call:
`load_permissions_and_authorize_resource`

before all your controller methods.

It will load and evaluate all user permissions, but also prepare your standard
actions by loading the resources.

If the command is called in the beginning, your `show`-action can be change
from:
```
def show
  @news = News.find(params[:id])
end
```

to:

```
def show
end
```

With the same results!

The same goes for `:edit, :new, :index, :create, :update, :destroy`.

All you need to add for standard functionality is in the end, under the
`private` scope:
```
private

def news_params
  params.require(:news).permit(:title,..
end
```

---------------------

Happy coding!
