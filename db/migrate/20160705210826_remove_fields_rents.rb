class RemoveFieldsRents < ActiveRecord::Migration
  def change
    remove_column(:rents, :lastname, :string)
    remove_column(:rents, :firstname, :string)
    remove_column(:rents, :email, :string)
    remove_column(:rents, :phone, :string)

    add_foreign_key(:rents, :users)
    add_index(:rents, :user_id)
    add_index(:rents, :council_id)
  end
end
