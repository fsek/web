class AddExtraTextToPost < ActiveRecord::Migration
  def change
    add_column :posts,:extra_text,:boolean
    add_column :elections,:extra_text,:text
  end
end
