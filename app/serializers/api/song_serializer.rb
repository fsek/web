class Api::SongSerializer < ActiveModel::Serializer

  class Api::SongSerializer::Multiple < ActiveModel::Serializer
    attributes(:id, :title)
  end

  class Api::SongSerializer::Single < ActiveModel::Serializer
    attributes(:id, :title, :author, :melody, :content)
    
    def content
      MarkdownHelper.markdown_api(object.content)
    end
  end
end
