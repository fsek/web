module EventHelper
  def event_stream_date(event)
    if event.present?
      I18n.l(event.starts_at, format: ' %H:%M')
    end
  end

  def event_attendees(event)
    content = []
    content << content_tag(:li) do
      safe_join([icon('fas', 'user'), " #{I18n.t('model.event.attending')}: #{EventUser.attending_count(event)}"])
    end

    content << content_tag(:li) do
      safe_join([icon('fas', 'users'), " #{EventSignup.human_attribute_name(:slots)}: #{event.signup.slots}"])
    end

    reserves = EventUser.reserve_count(event)
    if reserves > 0
      content << content_tag(:li) do
        safe_join([icon('fas', 'user-times'), " #{I18n.t('model.event.reserves')}: #{reserves}"])
      end
    end

    content << content_tag(:li) do
      safe_join([icon('fas', 'calendar-check'),
                 " #{EventSignup.human_attribute_name(:opens)}: #{l(event.signup.opens, format: :short)}"])
    end

    content << content_tag(:li) do
      safe_join([icon('fas', 'calendar-times'),
                 " #{EventSignup.human_attribute_name(:closes)}: #{l(event.signup.closes, format: :short)}"])
    end

    content_tag(:span, content_tag(:ul, safe_join(content)), class: 'event info')
  end

  def event_reg_status(event_signup, event_user)
    if event_user.persisted?
      persisted_event_user_status(event_signup, event_user)
    else
      event_status_span('not-attending lg', 'fas', 'exclamation-circle', t('.not_attending'))
    end
  end

  def persisted_event_user_status(event_signup, event_user)
    if event_signup.closed?
      if event_signup.lottery?
          event_status_span('attending lg', 'fas', 'exclamation-circle', t('.lottery-processing'))
      else
        if event_user.reserve?
          event_status_span('reserve lg', 'fas', 'exclamation-circle', t('.reserve'))
        else
          event_status_span('attending lg', 'fas', 'check-circle', t('.attending'))
        end
      end
    else
      if event_signup.lottery?
        event_status_span('registered lg', 'fas', 'question-circle', t('.registered-lottery'))
      else
        event_status_span('registered lg', 'fas', 'question-circle', t('.registered'))
      end
    end
  end

  def event_status_span(status, icon_prefix, icon, text)
    content_tag(:span, class: "event #{status}") do
      icon(icon_prefix, icon) + ' ' + text
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

  def event_user_types(event_signup, user, include_other: true)
    types = map_event_user_types(event_signup, event_signup.selectable_types(user))

    if include_other
      types << [t('model.event_signup.user_types.other'), '']
    end

    types
  end

  def admin_event_user_types(event_signup)
    map_event_user_types(event_signup, event_signup.order)
  end

  def map_event_user_types(event_signup, types)
    types.map do |type|
      [event_user_type(event_signup, type), type]
    end
  end

  def event_user_groups(event_signup, user)
    groups = user.groups.merge(event_signup.selectable_groups).pluck(:name, :id)
    groups << ['', nil]
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

  def group_str(event_user)
    event_user.group.present? ? event_user.group : event_user.group_custom
  end

  def event_signup_status(event)
    if event.signup.present?
      if event.signup.open?
        content_tag(:span, icon('far', 'dot-circle'),
                    class: 'open',
                    'data-toggle': 'tooltip',
                    title: I18n.t('helper.event.signup_open'))
      elsif event.signup.closed?
        content_tag(:span, icon('far', 'dot-circle'),
                    class: 'closed',
                    'data-toggle': 'tooltip',
                    title: I18n.t('helper.event.signup_closed'))
      else
        content_tag(:spab, icon('far', 'dot-circle'),
                    class: 'future',
                    'data-toggle': 'tooltip',
                    title: I18n.t('helper.event.signup_future'))
      end
    end
  end

  def drink_package_answer_collection
    [[I18n.t('model.event_user.drink_package_answers.none'), EventUser::ALCOHOL_PACKAGE_ANSWER_NONE],
     [I18n.t('model.event_user.drink_package_answers.alcohol'), EventUser::ALCOHOL_PACKAGE_ANSWER_ALCOHOL],
     [I18n.t('model.event_user.drink_package_answers.alcohol_free'), EventUser::ALCOHOL_PACKAGE_ANSWER_ALCOHOL_FREE]]
  end
end
