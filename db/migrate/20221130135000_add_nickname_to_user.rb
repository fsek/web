class AddNicknameToUserSoICanRevert < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :moose_game_nickname, :string, null: true
  end
end
