class AddUseCaseToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column(:categories, :use_case, :string, default: 'general', null: :false, index: true)
  end
end
