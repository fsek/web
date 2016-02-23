class ChangeFieldsOnPost < ActiveRecord::Migration
  def change
    rename_column :posts, :elected_at, :semester
    rename_column :posts, :recLimit, :rec_limit
    rename_column :posts, :styrelse, :board

    change_column_default :posts, :semester, 'both'

    remove_column :posts, :election_text, :string
    remove_column :posts, :extra_text, :boolean
  end
end
