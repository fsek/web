class ChangeWorkPost3 < ActiveRecord::Migration
  def change
    remove_column :work_posts,:type,:string
    add_column :work_posts,:kind,:string
  end
end
