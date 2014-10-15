class ChangeStyrChoiceAtPost < ActiveRecord::Migration
  def change
    remove_column :posts,:styrChoice,:boolean
    add_column :posts,:elected_by,:string
    remove_column :posts,:ht,:boolean
    add_column :posts,:elected_at,:string
  end
end
