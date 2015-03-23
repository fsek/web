require 'rails_helper'

RSpec.describe PermissionPost, type: :model do
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:subject_type) }
end
