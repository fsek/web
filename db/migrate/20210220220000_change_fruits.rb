class ChangeFruits < ActiveRecord::Migration[5.0]
  def change
    rename_column :fruits, :isMoldy, :is_moldy
  end
end
