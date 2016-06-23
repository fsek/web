require 'rails_helper'
RSpec.feature 'Groups' do
  scenario 'group member visits group' do
    user = create(:user)
    group = create(:group, name: 'Godtycklig grupp')
    create(:group_user, group: group, user: user)

    sign_in_as(user)

    page.visit(group_path(group))
    page.should have_css('div.group-user-list')
    page.should have_text(group.name)
    page.should_not have_css('div.alert.alert-danger')
  end

  scenario 'non group member visits group' do
    user = create(:user)
    group = create(:group, name: 'Godtycklig grupp')

    sign_in_as(user)

    page.visit(group_path(group))
    page.should_not have_text(group.name)
    page.should have_css('div.alert.alert-danger')
    find('div.alert.alert-danger').text.should include(I18n.t('unauthorized.manage.all',
                                                              action: 'show',
                                                              subject: 'group'))
  end

  scenario 'fadder visits #edit' do
    user = create(:user)
    group = create(:group, name: 'Godtycklig grupp')
    create(:group_user, group: group, user: user, fadder: true)

    sign_in_as(user)

    page.visit(edit_group_path(group))
    page.should have_text(I18n.t('groups.edit.title'))
    page.should_not have_css('div.alert.alert-danger')
  end

  scenario 'nolla visits #edit' do
    user = create(:user)
    group = create(:group, name: 'Godtycklig grupp')
    create(:group_user, group: group, user: user)

    sign_in_as(user)

    page.visit(edit_group_path(group))
    page.should_not have_text(I18n.t('groups.edit.title'))
    page.should have_css('div.alert.alert-danger')
    find('div.alert.alert-danger').text.should include(I18n.t('unauthorized.manage.all',
                                                              action: :edit,
                                                              subject: 'group'))
  end
end
