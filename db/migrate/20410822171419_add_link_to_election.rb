class AddLinkToElection < ActiveRecord::Migration
  def change
    add_column :elections,:mail_link,:string    
    add_column :elections,:candidate_mail_star,:text
  end
end
