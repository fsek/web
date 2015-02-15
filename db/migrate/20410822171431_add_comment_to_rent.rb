class AddCommentToRent < ActiveRecord::Migration
  def change
    remove_column :rents,:confirmed,:boolean
    add_column :rents,:comment,:text
    add_column :rents,:status, :string
  end
end
