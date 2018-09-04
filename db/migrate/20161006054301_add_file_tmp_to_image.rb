class AddFileTmpToImage < ActiveRecord::Migration[5.0]
  def change
    add_column(:images, :file_tmp, :string)
  end
end
