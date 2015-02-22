class AddRemoveWorkerBooleanToCafeWork < ActiveRecord::Migration
  def change
    add_column :cafe_works, :remove_worker, :boolean
  end
end
