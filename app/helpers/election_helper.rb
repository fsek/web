module ElectionHelper
  def can_candidate?(election, post)
    if election.present? && post.present?
      case election.state
      when :during
        return true
      when :after
        return !(post.elected_by == Post::GENERAL)
      end
    end

    false
  end

  def candidate_and_nominate_buttons(post)
    if post.present?
      candidate = link_to(I18n.t('candidate.new'), new_candidate_path(post: post.id.to_s),
                          class: 'btn primary')
      nomination = link_to(I18n.t('nomination.new'), new_nominations_path(post: post.id.to_s),
                           class: 'btn primary')
      safe_join([candidate, nomination])
    end
  end

  def election_post_link(post)
    if post.present?
      title = content_tag(:span, post.title)
      show = link_to(post_path(post), class: 'btn secondary') do
        fa_icon('external-link')
      end
      modal = link_to(modal_post_path(post), remote: true, class: 'btn secondary') do
        fa_icon('object-group')
      end
      safe_join([show, modal, title])
    end
  end
end
