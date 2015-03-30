class AddFieldsToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :name, :string
    add_column :candidates, :lastname, :string
    add_index :candidates, :profile_id
    add_index :candidates, :post_id
  end
end
