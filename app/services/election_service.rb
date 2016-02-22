module ElectionService
  def self.create_candidate(candidate, user)
    candidate.user = user
    candidate.validate!
    if !candidate.election.current_posts.exists?(candidate.post.id)
      candidate.errors.add(:post, I18n.t('election.not_allowed_post'))
      return false
    end

    candidate.save!
  end

  def self.destroy_candidate(candidate)
    if candidate.editable?
      candidate.destroy!
    else
      false
    end
  end
end
