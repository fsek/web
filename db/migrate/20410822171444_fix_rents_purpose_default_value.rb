class FixRentsPurposeDefaultValue < ActiveRecord::Migration
  def change
    change_column :rents, :purpose, :text, :default => nil
  end
end
