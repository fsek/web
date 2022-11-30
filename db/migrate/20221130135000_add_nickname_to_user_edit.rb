class AddNicknameToUserEdit < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :game_nickname, :string, null: true
  end
end
