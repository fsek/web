module ElectionService
  def self.create_candidate(candidate, user)
    candidate.user = user

    if candidate.save
      ElectionMailer.candidate_email(candidate).deliver_now
      true
    else
      false
    end
  end

  def self.destroy_candidate(candidate)
    if candidate.editable?
      candidate.destroy
    else
      false
    end
  end
end
