require 'rails_helper'

RSpec.describe ElectionMailer, type: :mailer do
  describe 'nomination' do
    it 'has appropriate subject' do
      nomination = build_stubbed(:nomination)

      mail = ElectionMailer.nominate_email(nomination)

      mail.subject.should eq(I18n.t('election_mailer.nominate_email.subject_nominated'))
    end

    it 'sends from dirac' do
      nomination = build_stubbed(:nomination)

      mail = ElectionMailer.nominate_email(nomination)

      mail.from.should eq(['valb@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      nomination = build_stubbed(:nomination)

      mail = ElectionMailer.nominate_email(nomination)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'includes the text' do
      nomination = build_stubbed(:nomination,
                                 motivation: 'What a wonderful day')

      mail = ElectionMailer.nominate_email(nomination)
      mail.body.should include('What a wonderful day')
    end
  end

  describe 'candidate' do
    it 'has appropriate subject' do
      candidate = build_stubbed(:candidate)

      mail = ElectionMailer.candidate_email(candidate)

      mail.subject.should eq(I18n.t('election_mailer.candidate_email.subject_candidated'))
    end

    it 'sends from dirac' do
      candidate = build_stubbed(:candidate)

      mail = ElectionMailer.candidate_email(candidate)

      mail.from.should eq(['valb@fsektionen.se'])
    end

    it 'Message-ID has right domain' do
      candidate = build_stubbed(:candidate)

      mail = ElectionMailer.candidate_email(candidate)

      mail.message_id.should include('@fsektionen.se')
    end

    it 'board post' do
      election = build_stubbed(:election,
                               candidate_mail: 'This is the general and board email',
                               candidate_mail_star: 'This is the not general email',
                               nominate_mail: 'This is the nomination email')

      postt = build_stubbed(:post, elected_by: Post::GENERAL, board: true)
      election.posts << postt
      candidate = build_stubbed(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate)
      mail.body.should include('This is the general and board email')
    end

    it 'post elected at general meeting' do
      election = build_stubbed(:election,
                               candidate_mail: 'This is the general and board email',
                               candidate_mail_star: 'This is the not general email',
                               nominate_mail: 'This is the nomination email')

      postt = build_stubbed(:post, elected_by: Post::GENERAL, board: false)
      election.posts << postt
      candidate = build_stubbed(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate)
      mail.body.should include('This is the general and board email')
    end

    it 'posts not elected at general meeting' do
      election = build_stubbed(:election,
                               candidate_mail: 'This is the general and board email',
                               candidate_mail_star: 'This is the not general email',
                               nominate_mail: 'This is the nomination email')

      postt = build_stubbed(:post, elected_by: Post::BOARD, board: false)
      election.posts << postt
      candidate = build_stubbed(:candidate, post: postt, election: election)

      mail = ElectionMailer.candidate_email(candidate)
      mail.body.should include('This is the not general email')
    end
  end
end
