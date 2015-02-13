class AddLastnameToProfile < ActiveRecord::Migration
  def change
    add_column :profiles,:lastname, :string
  end
end
