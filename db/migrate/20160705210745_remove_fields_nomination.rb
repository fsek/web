class RemoveFieldsNomination < ActiveRecord::Migration
  def change
    remove_column(:nominations, :phone, :string)
    remove_column(:nominations, :stil_id, :string)
  end
end
