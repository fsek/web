module PositionHelper
  def print_position_limit(position)
    if position.present?
      if position.rec_limit == 0 && position.limit == 0 || position.rec_limit > position.limit
        '*'
      elsif position.rec_limit == position.limit && position.rec_limit > 0
        %(#{position.limit} (x))
      elsif position.limit > 0 && position.rec_limit == 0
        position.limit
      elsif position.limit > position.rec_limit
        %(#{position.recLimit} - #{position.limit})
      end
    end
  end

  def position_tab_header(positions)
    if positions.present?
      content_tag(:ul, class: 'nav nav-tabs') do
        content = []
        content << position_tab_link(positions.first, first: true)
        positions.offset(1).each do |position|
          content << position_tab_link(position)
        end
        safe_join(content)
      end
    end
  end

  def position_tab(positions)
    if positions.present?
      content = []
      content << position_tab_element(positions.first, first: true)
      positions.offset(1).each do |position|
        content << position_tab_element(position)
      end
      safe_join(content)
    end
  end

  def position_tab_element(position, first: false)
    if first
      content_tag(:div, id: dom_id(position), class: 'tab-pane fade in active') do
        safe_join([position_tab_description(position), position_tab_users(position)])
      end
    else
      content_tag(:div, id: dom_id(position), class: 'tab-pane fade in') do
        safe_join([position_tab_description(position), position_tab_users(position)])
      end
    end
  end

  def position_tab_link(position, first: false)
    if position.present?
      if first
        content_tag(:li, class: :active) do
          link_to(position, %(##{dom_id(position)}), data: { toggle: :tab })
        end
      else
        content_tag(:li) do
          link_to(position, %(##{dom_id(position)}), data: { toggle: :tab })
        end
      end
    end
  end

  def position_tab_description(position)
    if position.present?
      content_tag(:div, class: 'col-sm-8') do
        content = []
        content << content_tag(:div, class: :headline) do
          content_tag(:h4) do
            Position.human_attribute_name(:description)
          end
        end
        content << markdown(position.description)
        safe_join(content)
      end
    end
  end

  def position_tab_users(position)
    if position.present?
      content_tag(:div, class: 'col-sm-4') do
        content = []
        content << content_tag(:div, class: :headline) do
          content_tag(:h4) do
            t('helper.position.who_currently')
          end
        end
        content << position_users_list(position)
        safe_join(content)
      end
    end
  end

  def position_users_list(position)
    if position.present?
      content_tag(:ul, class: :list) do
        content = []

        position.users.each do |user|
          content << content_tag(:li) do
            user_link(user)
          end
        end

        safe_join(content)
      end
    end
  end
end
