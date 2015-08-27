class AddFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :council_id, :integer
    add_column :events, :user_id, :integer

    add_column :events, :short, :string

    add_column :events, :signup, :boolean
    add_column :events, :last_reg, :datetime
    add_column :events, :dot, :string
    add_column :events, :slots, :integer

    add_column :events, :drink, :boolean
    add_column :events, :food, :boolean
    add_column :events, :cash, :boolean
  end
end
