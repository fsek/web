require 'rails_helper'

RSpec.describe ElectionMailer, type: :mailer do
  describe 'nomination' do
    it 'has appropriate subject' do
      nomination = create(:nomination)

      mail = ElectionMailer.nominate_email(nomination.id)

      mail.subject.should eq(I18n.t('election_mailer.nominate_email.subject_nominated'))
    end

    it 'sends from dirac' do
      nomination = create(:nomination)

      mail = ElectionMailer.nominate_email(nomination.id)

      mail.from.should eq(['valb@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      nomination = create(:nomination)

      mail = ElectionMailer.nominate_email(nomination.id)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      nomination = create(:nomination,
                          motivation: 'What a wonderful day')

      mail = ElectionMailer.nominate_email(nomination.id)
      mail.body.should include('What a wonderful day')
    end
  end

  describe 'candidate' do
    it 'has appropriate subject' do
      candidate = create(:candidate)

      mail = ElectionMailer.candidate_email(candidate.id)

      mail.subject.should eq(I18n.t('election_mailer.candidate_email.subject_candidated'))
    end

    it 'sends from dirac' do
      candidate = create(:candidate)

      mail = ElectionMailer.candidate_email(candidate.id)

      mail.from.should eq(['valb@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      candidate = create(:candidate)

      mail = ElectionMailer.candidate_email(candidate.id)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'board post' do
      election = create(:election, :before_general, :autumn,
                        candidate_mail: 'This is the general and board email',
                        candidate_mail_star: 'This is the not general email',
                        nominate_mail: 'This is the nomination email')

      postt = create(:post, :autumn, :general, board: true)
      candidate = create(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate.id)
      mail.body.should include('This is the general and board email')
    end

    it 'post elected at general meeting' do
      election = create(:election, :before_general, :autumn,
                        candidate_mail: 'This is the general and board email',
                        candidate_mail_star: 'This is the not general email',
                        nominate_mail: 'This is the nomination email')

      postt = create(:post, :autumn, :general, board: false)
      candidate = create(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate.id)
      mail.body.should include('This is the general and board email')
    end

    it 'posts not elected at general meeting' do
      election = create(:election, :before_general, :autumn,
                        candidate_mail: 'This is the general and board email',
                        candidate_mail_star: 'This is the not general email',
                        nominate_mail: 'This is the nomination email')

      postt = create(:post, :autumn, :board, board: false)
      candidate = create(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate.id)
      mail.body.should include('This is the not general email')
    end
  end
end
