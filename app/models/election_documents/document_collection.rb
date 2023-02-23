class DocumentCollection < ApplicationRecord
    validates :collection_name, presence: true, uniqueness: true

    has_many :election_documents, dependent: :destroy
end
