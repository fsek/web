module GroupHelper
  def group_user_name(group_user)
    group_user.fadder ? safe_join([group_user.user, ' ', fa_icon('graduation-cap')]) : group_user.user
  end

  def group_user_state_link(group, group_user)
    if group.present? && group_user.present?
      if group_user.fadder
        link_to(I18n.t('helper.group.set_nolla'),
                set_not_fadder_admin_group_group_user_path(group, group_user),
                method: :patch,
                remote: true)
      else
        link_to(I18n.t('helper.group.set_fadder'),
                set_fadder_admin_group_group_user_path(group, group_user),
                method: :patch,
                remote: true)
      end
    end
  end

  def group_title(group)
    if group.present?
      model_name(Group) + ' ' + @group.number.to_s + ': ' + @group.name
    end
  end
end
