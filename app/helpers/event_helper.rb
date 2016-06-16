module EventHelper
  def event_stream_date(event)
    if event.present?
      I18n.l(event.starts_at, format: ' %H:%M')
    end
  end

  def event_attendees(event)
    content = []
    content << content_tag(:li) do
      safe_join([fa_icon('user'), " #{I18n.t('model.event.attending')}: #{EventRegistration.attending_count(event)}"])
    end

    content << content_tag(:li) do
      safe_join([fa_icon('users'), " #{Event.human_attribute_name(:slots)}: #{event.slots}"])
    end

    reserves = EventRegistration.reserve_count(event)
    if reserves > 0
      content << content_tag(:li) do
        safe_join([fa_icon('user-times'), " #{I18n.t('model.event.reserves')}: #{reserves}"])
      end
    end

    content << content_tag(:li) do
      safe_join([fa_icon('calendar-o'),
                 " #{Event.human_attribute_name(:last_reg)} : #{l(event.last_reg, format: :short)}"])
    end

    content_tag(:span, content_tag(:ul, safe_join(content)), class: 'event info')
  end

  def event_reg_status(registration)
    if registration.persisted?
      if !registration.reserve
        # Attending
        event_status_span('attending', 'check-circle-o', t('.attending'))
      else
        event_status_span('reserve', 'question-circle',
                          t('.reserve', count: registration.reserve_position))
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
      elsif !user.member? && event.for_members
        content << I18n.t('helper.event.membership_required')
        content << contact_from_slug(slug: :spindelman)
      end

      content_tag(:span, safe_join(content), class: 'event not-registered') if content.any?
    end
  end
end
