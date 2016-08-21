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
end
