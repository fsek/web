class AddNominationTextPost < ActiveRecord::Migration
  def change
    add_column :posts,:election_text,:text
  end
end
