class ChangeDataTypeForDrinkPackageAnswer < ActiveRecord::Migration[5.1]
  def self.up
    change_table :event_users do |t|
      t.change :drink_package_answer, :string
    end
  end
  def self.down
    change_table :event_users do |t|
      t.change :drink_package_answer, :boolean
    end
  end
end
