class Api::ContactsSerializer < ActiveModel::Serializer
  
  class Api::ContactsSerializer::Show < ActiveModel::Serializer
    attributes(:email, :name, :text)
  end

  class Api::ContactsSerializer::Index < ActiveModel::Serializer
    attributes(:id, :email, :name, :text)

    def text
      MarkdownHelper.markdown_api(object.text)
    end
  end
end
