class AddFieldsToElection < ActiveRecord::Migration
  def change
    add_column :elections,:candidate_mail,:text
    add_column :elections,:nominate_mail,:text
    add_column :elections,:text_before,:text
    add_column :elections,:text_during,:text
    add_column :elections,:text_after,:text
    add_column :profiles,:phone,:string
  end
end
