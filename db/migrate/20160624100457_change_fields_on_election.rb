class ChangeFieldsOnElection < ActiveRecord::Migration
  def change
    add_column :elections, :semester, :string, default: 'spring'
    rename_column :elections, :mail_styrelse_link, :board_mail_link
    rename_column :elections, :start, :open
    rename_column :elections, :end, :close_general
    rename_column :elections, :closing, :close_all

    remove_column :elections, :text_before, :text
    remove_column :elections, :text_during, :text
    remove_column :elections, :text_after, :text
    remove_column :elections, :extra_text, :text
  end
end
