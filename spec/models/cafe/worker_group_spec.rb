require 'rails_helper'

RSpec.describe Cafe::WorkerGroup, type: :model do
  it { should validate_presence_of(:worker) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:worker) }
  it { should belong_to(:group) }
end
