class ChangeWorkPost2 < ActiveRecord::Migration
  def change
    add_column :work_posts,:link,:string
  end
end
