class RenameCafeWorkCouncil < ActiveRecord::Migration
  def change
    rename_table :cafe_work_councils, :cafe_worker_councils
    rename_column :cafe_worker_councils, :cafe_work_id, :cafe_worker_id
    add_index :cafe_worker_councils, :cafe_worker_id
    add_index :cafe_worker_councils, :council_id
  end
end
