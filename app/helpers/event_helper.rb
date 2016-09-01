module EventHelper
  def event_stream_date(event)
    if event.present?
      I18n.l(event.starts_at, format: ' %H:%M')
    end
  end

  def event_attendees(event)
    content = []
    content << content_tag(:li) do
      safe_join([fa_icon('user'), " #{I18n.t('model.event.attending')}: #{EventUser.attending_count(event)}"])
    end

    content << content_tag(:li) do
      safe_join([fa_icon('users'), " #{EventSignup.human_attribute_name(:slots)}: #{event.signup.slots}"])
    end

    reserves = EventUser.reserve_count(event)
    if reserves > 0
      content << content_tag(:li) do
        safe_join([fa_icon('user-times'), " #{I18n.t('model.event.reserves')}: #{reserves}"])
      end
    end

    content << content_tag(:li) do
      safe_join([fa_icon('calendar-check-o'),
                 " #{EventSignup.human_attribute_name(:opens)}: #{l(event.signup.opens, format: :short)}"])
    end

    content << content_tag(:li) do
      safe_join([fa_icon('calendar-times-o'),
                 " #{EventSignup.human_attribute_name(:closes)}: #{l(event.signup.closes, format: :short)}"])
    end

    content_tag(:span, content_tag(:ul, safe_join(content)), class: 'event info')
  end

  def event_reg_status(event_user)
    if event_user.persisted?
      if event_user.reserve?
        event_status_span('reserve', 'question-circle',
                          t('.reserve', count: event_user.reserve_position))
      else
        event_status_span('attending', 'check-circle-o',
                          t('.attending', count: event_user.position, max: event_user.event_signup.slots))
      end
    else
      event_status_span('not-attending', 'exclamation-circle', t('.not_attending'))
    end
  end

  def event_status_span(status, icon, text)
    content_tag(:span, class: "event #{status}") do
      fa_lg_icon(icon) + ' ' + text
    end
  end

  def event_reg_logged_in_or_member(event, user)
    content = []
    if event.try(:signup)
      if user.nil?
        content << I18n.t('helper.event.need_to_sign_in')
      elsif !user.member? && event.signup.for_members
        content << I18n.t('helper.event.membership_required')
        content << contact_from_slug(slug: :spindelman)
      end

      content_tag(:span, safe_join(content), class: 'event not-registered') if content.any?
    end
  end

  def event_user_type(event_signup, type)
    if type == EventSignup::CUSTOM
      event_signup.custom_name
    elsif type.blank?
      I18n.t('model.event_signup.user_types.other')
    else
      I18n.t("model.event_signup.user_types.#{type}")
    end
  end

  def event_user_types(event_signup, user)
    map_event_user_types(event_signup, event_signup.selectable_types(user))
  end

  def admin_event_user_types(event_signup)
    map_event_user_types(event_signup, event_signup.order)
  end

  def map_event_user_types(event_signup, types)
    types.map do |type|
      [event_user_type(event_signup, type), type]
    end
  end

  def dress_codes(event)
    event.dress_code.join(I18n.t('helper.event.or'))
  end

  def dress_code_collection
    [I18n.t('model.event.dress_codes.overall'),
     I18n.t('model.event.dress_codes.theme'),
     I18n.t('model.event.dress_codes.formal'),
     I18n.t('model.event.dress_codes.dark_suit'),
     I18n.t('model.event.dress_codes.white_tie')]
  end
end
