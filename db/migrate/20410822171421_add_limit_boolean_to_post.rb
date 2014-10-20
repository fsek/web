class AddLimitBooleanToPost < ActiveRecord::Migration
  def change
    add_column :posts,:limitBool,:boolean, default: false
  end
end
