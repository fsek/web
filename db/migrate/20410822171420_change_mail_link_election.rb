class ChangeMailLinkElection < ActiveRecord::Migration
  def change
    remove_column :elections,:mail_link,:string
    add_column :elections,:mail_link,:string
    add_column :elections,:mail_styrelse_link,:string    
  end
end
