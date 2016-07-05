module ElectionHelper
  def election_meta_description(election)
    if election.description.present?
      markdown_plain(election.description)
    else
      t('.description')
    end
  end

  def candidate_and_nominate_buttons(post)
    if post.present?
      candidate = link_to(I18n.t('helper.election.new_candidate'),
                          new_candidate_path(post: post.id.to_s),
                          class: 'btn primary')
      nomination = link_to(I18n.t('helper.election.new_nomination'),
                           new_nominations_path(post: post.id.to_s),
                           class: 'btn primary')
      safe_join([candidate, nomination])
    end
  end

  def election_post_link(post)
    if post.present?
      title = content_tag(:span, post.title)
      show = link_to(post_path(post), target: :blank, class: 'links') do
        fa_icon('external-link')
      end
      modal = link_to(modal_post_path(post), remote: true, class: 'links') do
        fa_icon('object-group')
      end
      safe_join([show, modal, title])
    end
  end
end
