class CreateApiImages < ActiveRecord::Migration[5.0]
    def change
        create_table :api_images do |t|
            t.string :file, limit: 255
            t.string :filename, limit: 255
        end
    end
end
