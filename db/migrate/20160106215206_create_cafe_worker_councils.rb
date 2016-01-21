class CreateCafeWorkerCouncils < ActiveRecord::Migration
  def change
    create_table :cafe_worker_councils do |t|
      t.integer :cafe_worker_id, index: true, null: :false
      t.integer :council_id, index: true, null: :false
    end
  end
end
