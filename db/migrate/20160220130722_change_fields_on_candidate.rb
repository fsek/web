class ChangeFieldsOnCandidate < ActiveRecord::Migration
  def change
    remove_column :candidates, :firstname, :string
    remove_column :candidates, :lastname, :string
    remove_column :candidates, :name, :string
    remove_column :candidates, :stil_id, :string
    remove_column :candidates, :email, :string
    remove_column :candidates, :phone, :string
    remove_column :candidates, :motivation, :text

    add_index :candidates, :election_id
    add_index :candidates, :user_id
  end
end
