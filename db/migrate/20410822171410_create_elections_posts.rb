class CreateElectionsPosts < ActiveRecord::Migration
  def change    
    create_table :elections_posts, id: false do |t|
      t.integer :election_id
      t.integer :post_id
    end
  end
end
