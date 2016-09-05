class ChangeEvent < ActiveRecord::Migration
  def change
    add_column(:events, :price, :integer)
    add_column(:events, :dress_code, :string)
  end
end
