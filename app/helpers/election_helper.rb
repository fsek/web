module ElectionHelper
  def election_meta_description(election)
    if election.description.present?
      markdown_plain(election.description)
    else
      t('.description')
    end
  end
end
