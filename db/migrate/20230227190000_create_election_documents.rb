class CreateElectionDocuments < ActiveRecord::Migration[5.0]
    def change
        create_table :document_collections do |t|
            t.string :collection_name, null: false
        end

        create_table :election_documents do |t|
            t.string :url, null: false
            t.string :document_name, null: false
            t.string :document_type, null: false
            t.references :document_collection
        end
    end
end
