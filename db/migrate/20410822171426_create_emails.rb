class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :email_account_id
      t.string :receiver
      t.string :subject
      t.text :message
      t.boolean :copy
      t.timestamps
    end
  end
end
