require 'rails_helper'

RSpec.describe Permission, type: :model do
  it { should validate_presence_of(:subject_class) }
  it { should validate_presence_of(:action) }
end
