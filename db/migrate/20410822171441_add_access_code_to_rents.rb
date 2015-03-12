class AddAccessCodeToRents < ActiveRecord::Migration
  def change
    add_column :rents, :access_code, :string
    change_column :rents, :service,:boolean, default: false
    change_column :rents, :disclaimer,:boolean, default: false
    change_column :rents, :purpose,:text, default: ""

    add_index :rents,:d_from
    add_index :rents,:d_til
  end
end
