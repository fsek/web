class AddBooleansToPost < ActiveRecord::Migration
  def change
    add_column :posts,:styrChoice,:boolean
    add_column :posts,:ht,:boolean  
  end
end
