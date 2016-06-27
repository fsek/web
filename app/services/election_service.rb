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
    candidate.editable? && candidate.destroy
  end

  def self.create_nomination(nomination)
    if nomination.save
      ElectionMailer.nominate_email(nomination).deliver_now
      true
    else
      false
    end
  end
end
