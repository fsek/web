class AddStyrelseToPost < ActiveRecord::Migration
  def change
    add_column :posts,:styrelse,:boolean
  end
end
