class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.boolean :public
      t.text :text
      t.integer :council_id

      t.timestamps
    end
  end
end
