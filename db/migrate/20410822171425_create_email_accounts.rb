class CreateEmailAccounts < ActiveRecord::Migration
  def change
    create_table :email_accounts do |t|
      t.integer :profile_id
      t.string :email
      t.string :title
      t.boolean :active

      t.timestamps
    end
  end
end
