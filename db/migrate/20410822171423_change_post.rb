class ChangePost < ActiveRecord::Migration
  def change
  add_column :posts,:recLimit,:integer, :default => 0
  change_column :posts, :limit,:integer, :default => 0
  remove_column :posts,:limitBool,:boolean 
  end
end
