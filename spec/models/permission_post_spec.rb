require 'rails_helper'

RSpec.describe PermissionPost, type: :model do
  it { should validate_presence_of(:permission) }
  it { should validate_presence_of(:post) }
end
