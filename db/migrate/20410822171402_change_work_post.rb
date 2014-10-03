class ChangeWorkPost < ActiveRecord::Migration
  def change
    add_column :work_posts,:category,:string
  end
end
