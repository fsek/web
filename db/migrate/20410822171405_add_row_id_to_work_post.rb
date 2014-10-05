class AddRowIdToWorkPost < ActiveRecord::Migration
  def change
    add_column :work_posts,:row_order,:integer
  end
end
