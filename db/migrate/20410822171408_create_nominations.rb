class CreateNominations < ActiveRecord::Migration
  def change
    create_table :nominations do |t|
      t.integer :post_id
      t.integer :election_id
      t.string :name
      t.string :stil
      t.string :email
      t.text :motivation

      t.timestamps
    end
  end
end
