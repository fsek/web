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
      if group.regular?
        t('helper.group.regular_title') + ' ' + group.number.to_s + ': ' + group.to_s
      else
        group.to_s
      end
    end
  end

  def group_type_str(group)
    if group.present?
      if group.regular?
        Group.human_attribute_name('regular')
      elsif group.mission?
        Group.human_attribute_name('mission')
      else
        Group.human_attribute_name('other')
      end
    end
  end

  def group_type_collection
    [[Group.human_attribute_name('regular'), Group::REGULAR],
     [Group.human_attribute_name('mission'), Group::MISSION],
     [Group.human_attribute_name('other'), Group::OTHER]]
  end
end
