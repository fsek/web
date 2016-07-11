class AddIntroductionToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :introduction, index: true, foreign_key: true
  end
end
