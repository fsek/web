require 'rails_helper'

RSpec.describe ElectionService do
  include ActiveJob::TestHelper

  describe 'create_candidate' do
    it 'creates a valid candidate' do
      election = create(:election, :before_general, :autumn)
      user = create(:user)
      the_post = create(:post, :autumn)

      candidate = election.candidates.build(post: the_post)
      lambda do
        ElectionService.create_candidate(candidate, user).should be_truthy
      end.should change(Candidate, :count).by(1)
    end

    it 'sends mail' do
      user = create(:user)
      candidate = build(:candidate, user: nil)

      lambda do
        ElectionService.create_candidate(candidate, user).should be_truthy
        perform_enqueued_jobs { ActionMailer::DeliveryJob.perform_now(*enqueued_jobs.first[:args]) }
      end.should change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'returns false if candidate invalid' do
      election = create(:election, :before_general, :autumn)
      user = create(:user)
      the_post = create(:post, :spring)

      candidate = election.candidates.build(post: the_post)
      lambda do
        ElectionService.create_candidate(candidate, user).should be_falsey
      end.should change(Candidate, :count).by(0)
    end
  end

  describe '#destroy_candidate' do
    it 'destroys candidate if editable' do
      candidate = create(:candidate)
      candidate.stub(:editable?).and_return(true)

      ElectionService.destroy_candidate(candidate).should be_truthy
    end

    it 'does not destroy candidate if not editable' do
      candidate = create(:candidate)
      candidate.stub(:editable?).and_return(false)

      ElectionService.destroy_candidate(candidate).should be_falsey
    end
  end

  describe '#create_nomination' do
    it 'valid parameters' do
      nomination = build(:nomination)

      lambda do
        ElectionService.create_nomination(nomination).should be_truthy
      end.should change(Nomination, :count).by(1)
    end

    it 'should send email' do
      nomination = build(:nomination)

      lambda do
        ElectionService.create_nomination(nomination).should be_truthy
        perform_enqueued_jobs { ActionMailer::DeliveryJob.perform_now(*enqueued_jobs.first[:args]) }
      end.should change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'invalid_parameters' do
      nomination = build(:nomination, email: nil)

      lambda do
        ElectionService.create_nomination(nomination).should be_falsey
      end.should change(Nomination, :count).by(0)
    end
  end
end
