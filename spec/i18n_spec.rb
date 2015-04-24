require 'i18n/tasks'

describe 'I18n' do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:missing_keys) { i18n.missing_keys }
  let(:unused_keys) { i18n.unused_keys }

  it 'does not have missing keys', pending: true do
    missing_keys.should be_empty,
    "Missing #{missing_keys.leaves.count}, check `i18n-tasks missing'"
  end

  it 'does not have unused keys' do
    unused_keys.should be_empty,
    "#{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to show them"
  end
end
