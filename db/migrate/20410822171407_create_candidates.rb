class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :post_id
      t.integer :profile_id
      t.integer :election_id
      t.text :motivation

      t.timestamps
    end
  end
end
