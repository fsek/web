class AddReferenceToElectionDocument < ActiveRecord::Migration[5.0]
    def change
      add_column(:election_documents, :reference, :integer)
    end
  end