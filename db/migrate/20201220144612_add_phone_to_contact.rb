class AddPhoneToContact < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :phone, :string
  end
end
