require 'rails_helper'

RSpec.describe CafeWorkCouncil, type: :model do
  it { should validate_presence_of(:cafe_work) }
  it { should validate_presence_of(:council) }
  it { should belong_to(:cafe_work) }
  it { should belong_to(:council) }
end
