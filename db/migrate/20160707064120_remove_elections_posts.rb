class RemoveElectionsPosts < ActiveRecord::Migration
  def up
    drop_table(:elections_posts)
  end

  def down
    create_table 'elections_posts', id: false, force: :cascade do |t|
      t.integer 'election_id', limit: 4
      t.integer 'post_id',     limit: 4
    end
  end
end
