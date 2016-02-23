class ChangeFieldsOnElection < ActiveRecord::Migration
  def change
    add_column :elections, :semester, :string, default: 'spring'
    rename_column :elections, :mail_styrelse_link, :board_mail_link
    rename_column :elections, :end, :stop

    remove_column :elections, :text_before, :text
    remove_column :elections, :text_during, :text
    remove_column :elections, :text_after, :text
    remove_column :elections, :extra_text, :text

    add_index :elections, :url
  end
end
