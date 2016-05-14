require 'rails_helper'

RSpec.describe PermissionPost, type: :model do
  it { PermissionPost.new.should validate_presence_of(:permission) }
  it { PermissionPost.new.should validate_presence_of(:post) }
end
