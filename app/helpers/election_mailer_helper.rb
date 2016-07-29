module ElectionMailerHelper
  def candidate_mail_link(candidate)
    if candidate.present? && candidate.position.present? && candidate.election.present?
      if candidate.position.board
        candidate.election.board_mail_link
      else
        candidate.election.mail_link
      end
    end
  end

  def candidate_mail_link_html(candidate)
    text = candidate_mail_link(candidate)
    if text.present?
      link_to(text, text)
    end
  end
end
