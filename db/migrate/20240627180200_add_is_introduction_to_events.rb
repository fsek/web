class AddIsIntroductionToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :is_introduction, :boolean
  end
end
