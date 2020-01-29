class Api::StoreProductSerializer < ActiveModel::Serializer
  class Api::StoreProductSerializer::Index < ActiveModel::Serializer
    attributes(:id, :name, :price, :in_stock, :image_url)
  end
end
