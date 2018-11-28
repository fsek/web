class AddTermsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :terms_version, :int, default: 0, null: false)
  end
end
