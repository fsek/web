class MigrateCafe < ActiveRecord::Migration[5.0]
  def up
    # Update all Cafe Shifts to the new model
    # Pass 1 => 2 hour pass (previously pass nr 1 and 2)
    # Pass 2 => 3 hour pass (previously pass nr 3 and 4)
    #
    # NOTE! We can not reverse this change!!
    CafeShift.where(pass: 2).update_all(pass: 1)
    CafeShift.where('pass = ? OR pass = ?', 3, 4).update_all(pass: 2)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
