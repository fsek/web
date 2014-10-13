class AddStilIdMailToProfile < ActiveRecord::Migration
  def change
    add_column :profiles,:stil_id,:string
    add_column :candidates,:stil_id,:string
    add_column :candidates,:email,:string  
    add_column :profiles, :phone , :string  
  end
end
