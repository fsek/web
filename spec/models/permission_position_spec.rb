require 'rails_helper'

RSpec.describe PermissionPosition, type: :model do
  it { PermissionPosition.new.should validate_presence_of(:permission) }
  it { PermissionPosition.new.should validate_presence_of(:position) }
end
