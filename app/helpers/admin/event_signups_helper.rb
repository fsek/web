module Admin::EventSignupsHelper
  def food_preferences_button(parameters, event)
    if parameters.present? && event.try(:food?)
      if show_food_preferences(parameters)
        link_to(t('.hide_food_preferences'), parameters.merge(food: false, tab: :attendees),
                class: 'btn secondary')
      else
        link_to(t('.show_food_preferences'), parameters.merge(food: true, tab: :attendees),
                class: 'btn secondary')
      end
    end
  end

  def answers_button(parameters, event)
    if parameters.present? &&
        event.present? &&
        event.signup.present? &&
        event.signup.question.present?
      if show_answers(parameters)
        link_to(t('.hide_answer'), parameters.merge(answer: false, tab: :attendees), class: 'btn secondary')
      else
        link_to(t('.show_answer'), parameters.merge(answer: true, tab: :attendees), class: 'btn secondary')
      end
    end
  end

  def show_answers(parameters)
    parameters.fetch(:answer, 'false') == 'true'
  end

  def show_food_preferences(parameters)
    parameters.fetch(:food, 'false') == 'true'
  end

  def event_signup_reminders_sent?(signup)
    return unless signup.present?
    content = []

    if signup.sent_position.present?
      content << content_tag(:span, class: 'position-reminder') do
                   safe_join([fa_icon('bell'),
                              I18n.t('model.event_signup.position_reminder_was_sent',
                                     date: localize(signup.sent_position))])

      end
    end

    if signup.sent_reminder.present?
      content << content_tag(:span, class: 'event-reminder') do
                   safe_join([fa_icon('bell'),
                              I18n.t('model.event_signup.reminder_was_sent',
                                     date: localize(signup.sent_reminder))])
      end
    end

    safe_join(content)
  end
end
