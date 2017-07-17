module MessageHelper
  def message_destroy_link(message)
    link_to(admin_message_path(message),
            method: :delete,
            class: '',
            data: { confirm: t('helper.message.destroy_message') }) do
      fa_icon('trash')
    end
  end

  def message_edit_link(message)
    link_to(edit_admin_message_path(message), class: '') do
      fa_icon('pencil')
    end
  end

  def message_receivers(message)
    tag(:br) + t('helper.message.to') + message.group_names
  end

  def message_form_params(edit, message)
    if edit
      [:admin, message]
    else
      [:admin, message.introduction, message]
    end
  end

  def group_preset(preset, introduction)
    if preset == Group::REGULAR
      introduction.groups.regular
    elsif preset == Group::MISSION
      introduction.groups.missions
    end
  end
end
