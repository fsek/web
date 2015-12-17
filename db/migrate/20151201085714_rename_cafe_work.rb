class RenameCafeWork < ActiveRecord::Migration
  def change
    rename_table :cafe_works, :cafe_shifts
  end
end
