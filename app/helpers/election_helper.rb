module ElectionHelper
  def election_meta_description(election)
    if election.description.present?
      markdown_plain(election.description)
    else
      t('.description')
    end
  end

  def candidate_and_nominate_buttons(position)
    if position.present?
      candidate = link_to(I18n.t('helper.election.new_candidate'),
                          new_candidate_path(position: position.id.to_s),
                          class: 'btn primary')
      nomination = link_to(I18n.t('helper.election.new_nomination'),
                           new_nominations_path(position: position.id.to_s),
                           class: 'btn primary')
      safe_join([candidate, nomination])
    end
  end

  def election_position_link(position)
    if position.present?
      title = content_tag(:span, position.title)
      show = link_to(position_path(position), target: :blank, class: 'links') do
        fa_icon('external-link')
      end
      modal = link_to(modal_position_path(position), remote: true, class: 'links') do
        fa_icon('object-group')
      end
      safe_join([show, modal, title])
    end
  end
end
