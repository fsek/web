# Preview all emails at http://localhost:3000/rails/mailers/elections
class ElectionsPreview < ActionMailer::Preview
  def candidate_email
    c = Candidate.new(id: 1,post: Post.first, profile: Profile.first, name: "David", lastname: "Wessman", email: "d.wessman@fsektionen.se",phone: "042-6122", stil_id: "tfy13hilbert", election: Election.first)
    ElectionMailer.candidate_email(c)
  end
  def nominate_email
    n = Nomination.new(id: 1,post: Post.first, election: Election.first, name: "David Wessman", email: "d.wessman@fsektionen.se", motivation: "Du skulle bli en fantastisk "+Post.first.title)
    ElectionMailer.nominate_email(n)
  end
end
