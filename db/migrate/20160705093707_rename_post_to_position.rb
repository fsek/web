class RenamePostToPosition < ActiveRecord::Migration
  def change
    rename_table(:posts, :positions)

    remove_foreign_key(:accesses, :posts)
    rename_column(:accesses, :post_id, :position_id)
    add_foreign_key(:accesses, :positions)

    remove_foreign_key(:candidates, :posts)
    rename_column(:candidates, :post_id, :position_id)
    add_foreign_key(:candidates, :positions)

    rename_column(:contacts, :post_id, :position_id)
    rename_column(:nominations, :post_id, :position_id)

    rename_table(:election_posts, :election_positions)
    remove_foreign_key(:election_positions, :posts)
    rename_column(:election_positions, :post_id, :position_id)
    add_foreign_key(:election_positions, :positions)

    rename_table(:permission_posts, :permission_positions)
    rename_column(:permission_positions, :post_id, :position_id)

    rename_table(:post_users, :position_users)
    rename_column(:position_users, :post_id, :position_id)
  end
end
