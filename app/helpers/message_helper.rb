module MessageHelper
  def message_destroy_link(message, admin)
    if admin
      link_to(admin_message_path(message),
              method: :delete,
              class: '',
              data: { confirm: t('helper.message.destroy_message') }) do
        fa_icon('trash')
      end
    elsif can?(:destroy, message)
      link_to(message_path(message),
              method: :delete,
              class: '',
              data: { confirm: t('helper.message.destroy_message') }) do
        fa_icon('trash')
      end
    end
  end

  def comment_destroy_link(comment, admin)
    if admin
      link_to(admin_message_message_comment_path(comment.message, comment),
              method: :delete,
              class: '',
              data: { confirm: t('helper.message.destroy_comment') }) do
        fa_icon('trash')
      end
    elsif can?(:destroy, comment)
      link_to(message_message_comment_path(comment.message, comment),
              method: :delete,
              class: '',
              data: { confirm: t('helper.message.destroy_comment') }) do
        fa_icon('trash')
      end
    end
  end

  def message_edit_link(message, admin)
    if admin
      link_to(edit_admin_message_path(message), class: '') do
        fa_icon('pencil')
      end
    end
  end

  def message_receivers(message, admin)
    if admin
      tag(:br) + t('helper.message.to') + message.group_names
    end
  end

  def comment_form_for(message, admin)
    if admin
      [:admin, message, message.message_comments.build]
    else
      [message, message.message_comments.build]
    end
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
