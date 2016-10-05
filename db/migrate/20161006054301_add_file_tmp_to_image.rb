class AddFileTmpToImage < ActiveRecord::Migration
  def change
    add_column(:images, :file_tmp, :string)
  end
end
