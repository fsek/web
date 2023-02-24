class ElectionDocument < ApplicationRecord
    validates :document_name, :url, presence: true
    validates :document_type, presence: true

    belongs_to :document_collection, required: true
end
